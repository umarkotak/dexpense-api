module Transactions
  class Summary < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :time_zone, :now_utc, :now_local,
        :limit, :offset, :group_id, :min_date, :max_date,
        :group_wallet_id, :direction_type, :category
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
      @params[:min_date] = (params[:now_local].beginning_of_month-params[:time_zone].hour).to_s unless @params[:min_date].to_s.present?
      @params[:max_date] = ((params[:now_local].beginning_of_month+1.month)-params[:time_zone].hour).to_s unless @params[:max_date].to_s.present?
      @params[:group_wallet_id] = nil if @params[:group_wallet_id].to_i == 0
      @params[:direction_type] = nil if @params[:direction_type] == 'all'
      @params[:category] = nil if @params[:category] == 'all'
    end

    def execute_logic
      @transactions = Transaction
        .select("
          category AS category,
          COUNT(1) AS count,
          SUM(amount) AS amount,
          direction_type AS direction_type
        ")
        .where(where_params)
        .where("transaction_at + interval '#{@params[:time_zone]} hour' >= :min_date", min_date: @params[:min_date])
        .where("transaction_at + interval '#{@params[:time_zone]} hour' < :max_date", max_date: @params[:max_date])
        .where("category != 'transfer'")
        .group("category, direction_type")
        .order(ordering)
    end


    def where_params
      {
        group_id: @params[:group_id],
        group_wallet_id: @params[:group_wallet_id],
        direction_type: @params[:direction_type],
        category: @params[:category]
      }.compact
    end

    def ordering
      "SUM(amount) DESC, category DESC"
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
