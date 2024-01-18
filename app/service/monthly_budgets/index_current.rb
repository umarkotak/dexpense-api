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
      @group.prefill_default

      # date format: YYYY-MM-DD
      @params[:min_date] = (params[:now_local].beginning_of_month - @params[:time_zone].hour).to_s unless @params[:min_date].to_s.present?
      @params[:max_date] = ((params[:now_local].beginning_of_month+1.month) - @params[:time_zone].hour).to_s unless @params[:max_date].to_s.present?
      # @params[:days_left] = (params[:now_local].end_of_month.to_date - params[:now_local].to_date).to_i
      @params[:days_left] = (group.payout_date.to_i - params[:now_local].day).to_i
      if @params[:days_left] <= 0
        @params[:days_left] = ((params[:now_local] + 1.months).change(day: group.payout_date.to_i) - params[:now_local]) / (24 * 60 * 60)
      end
    end

    def execute_logic
      total_expense = 0
      transactions = Transaction
        .select("
          category,
          monthly_budget_id,
          SUM(amount) as amount
        ")
        .where({
          group_id: @params[:group_id],
          direction_type: 'outcome'
        }.compact)
        .where("transaction_at >= :min_date", min_date: @params[:min_date])
        .where("transaction_at < :max_date", max_date: @params[:max_date])
        .group("category, monthly_budget_id")
      transaction_hash = {}
      transactions.to_a.each do |t|
        total_expense += t['amount'].to_i
        transaction_hash["#{t['category']}-#{t['monthly_budget_id']}"] = t['amount']
      end

      monthly_budgets = MonthlyBudget
        .where({group_id: @params[:group_id]}.compact)

      formatted_monthly_budgets = {
        total_budget: 0,
        used_budget: 0,
        days_left: @params[:days_left],
        monthly_sallary: group.monthly_sallary,
        total_expense: total_expense,
      }

      breakdowns = monthly_budgets.map do |mb|
        formatted_monthly_budgets[:total_budget] += mb.total_budget
        formatted_monthly_budgets[:used_budget] += transaction_hash[mb.category].to_i
        average_daily_remaining = ((mb.total_budget - transaction_hash[mb.category].to_i) / @params[:days_left])
        average_daily_remaining = 0 if average_daily_remaining < 0
        transaction_hash_key = ""
        if mb.mode == "generic"
          transaction_hash_key = "#{mb.category}-#{nil}"
        else
          transaction_hash_key = "#{mb.category}-#{mb.id}"
        end
        {
          "id": mb.id,
          "mode": mb.mode,
          "name": mb.name,
          "fa_icon": "fa fa-coins",
          "category": mb.category,
          "category_label": Const::TRANSACTION_CATEGORIES_MAP[mb.category][@params[:locale]],
          "total_budget": mb.total_budget,
          "used_budget": transaction_hash[transaction_hash_key].to_i,
          "remaining_budget": mb.total_budget - transaction_hash[transaction_hash_key].to_i,
          "average_daily_remaining_budget": average_daily_remaining,
          "used_percentage": ('%.2f' % (transaction_hash[transaction_hash_key].to_f / mb.total_budget.to_f)).to_f
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
