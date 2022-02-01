module Transactions
  class IndexMonthly < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :time_zone, :now_utc, :now_local,
        :limit, :offset, :group_id, :min_date, :max_date,
      )
    end

    def call
      validates
      initialize_default_value
      execute_logic
      @result = @transactions
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
      @params[:min_date] = (params[:now_local].beginning_of_year-params[:time_zone].hour).to_s unless @params[:min_date].to_s.present?
      @params[:max_date] = ((params[:now_local].beginning_of_year+1.year)-params[:time_zone].hour).to_s unless @params[:max_date].to_s.present?
    end

    def execute_logic
      @transactions = Transaction.preload(:account, :group_wallet)
        .select("
          DATE_TRUNC('month', transaction_at AT time zone INTERVAL '#{-@params[:time_zone]}') AS transaction_at_month,
          SUM(amount) AS amount,
          MAX(direction_type) AS direction_type,
          MAX(account_id) AS account_id,
          MAX(group_id) AS group_id,
          MAX(group_wallet_id) AS group_wallet_id
        ")
        .where(where_params)
        .where("transaction_at >= :min_date AND transaction_at < :max_date", min_date: @params[:min_date], max_date: @params[:max_date])
        .group("transaction_at_month, direction_type")
        .order(ordering)
    end

    def where_params
      {
        group_id: @params[:group_id]
      }.compact
    end

    def ordering
      "transaction_at_month desc"
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
