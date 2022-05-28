module MonthlyBudgets
  class IndexCurrent < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :locale, :time_zone, :now_utc, :now_local,
        :group_id, :min_date, :max_date,
      )
    end

    def call
      validates
      initialize_default_value
      execute_logic
      @result
    end

    private

    def validates
      raise "400 || Missing group" unless group.present?
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid group"
    end

    def initialize_default_value
      # date format: YYYY-MM-DD
      @params[:min_date] = (params[:now_local].beginning_of_month - @params[:time_zone].hour).to_s unless @params[:min_date].to_s.present?
      @params[:max_date] = ((params[:now_local].beginning_of_month+1.month) - @params[:time_zone].hour).to_s unless @params[:max_date].to_s.present?
      @params[:days_left] = (params[:now_local].end_of_month.to_date - params[:now_local].to_date).to_i
      @params[:days_left] = 1 if @params[:days_left] <= 0
    end

    def execute_logic
      transactions = Transaction
        .select("
          category,
          SUM(amount) as amount
        ")
        .where({
          group_id: @params[:group_id],
          direction_type: 'outcome'
        }.compact)
        .where("transaction_at >= :min_date", min_date: @params[:min_date])
        .where("transaction_at < :max_date", max_date: @params[:max_date])
        .group("category")
      transaction_hash = {}
      transactions.to_a.each { |t| transaction_hash[t['category']] = t['amount'] }

      monthly_budgets = MonthlyBudget
        .where({group_id: @params[:group_id]}.compact)

      formatted_monthly_budgets = {
        total_budget: 0,
        used_budget: 0,
        days_left: @params[:days_left],
      }

      breakdowns = monthly_budgets.map do |mb|
        formatted_monthly_budgets[:total_budget] += mb.total_budget
        formatted_monthly_budgets[:used_budget] += transaction_hash[mb.category].to_i
        average_daily_remaining = ((mb.total_budget - transaction_hash[mb.category].to_i) / @params[:days_left])
        average_daily_remaining = 0 if average_daily_remaining < 0
        {
          "fa_icon": "fa fa-coins",
          "category": mb.category,
          "category_label": Const::TRANSACTION_CATEGORIES_MAP[mb.category][@params[:locale]],
          "total_budget": mb.total_budget,
          "used_budget": transaction_hash[mb.category].to_i,
          "remaining_budget": mb.total_budget - transaction_hash[mb.category].to_i,
          "average_daily_remaining_budget": average_daily_remaining,
          "used_percentage": ('%.2f' % (transaction_hash[mb.category].to_f / mb.total_budget.to_f)).to_f
        }
      end
      formatted_monthly_budgets[:remaining_budget] = formatted_monthly_budgets[:total_budget] - formatted_monthly_budgets[:used_budget]
      formatted_monthly_budgets[:used_percentage] = ('%.2f' % (formatted_monthly_budgets[:used_budget].to_f / formatted_monthly_budgets[:total_budget].to_f)).to_f
      formatted_monthly_budgets[:breakdowns] = breakdowns

      @result = formatted_monthly_budgets
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
