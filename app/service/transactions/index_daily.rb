module Transactions
  class IndexDaily < BaseService
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
      @params[:min_date] = (params[:now_utc].beginning_of_day-params[:time_zone].hour).to_s unless @params[:min_date].to_s.present?
      @params[:max_date] = ((params[:now_utc]+1.day).beginning_of_day-params[:time_zone].hour).to_s unless @params[:max_date].to_s.present?
    end

    def execute_logic
      @transactions = Transaction.preload(:account, :group_wallet)
        .where(where_params)
        .where("transaction_at >= :min_date AND transaction_at < :max_date", min_date: @params[:min_date], max_date: @params[:max_date])
        .limit(@params[:limit])
        .offset(@params[:offset])
        .order(ordering)
    end

    def where_params
      {
        group_id: @params[:group_id]
      }.compact
    end

    def ordering
      "transaction_at desc, id desc"
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
