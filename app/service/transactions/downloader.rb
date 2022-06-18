module Transactions
  class Downloader < BaseService
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
      @result = @csv_results
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
      @transactions = Transaction.preload(:account, :group_wallet)
        .where(where_params)
        .where("transaction_at >= :min_date AND transaction_at < :max_date", min_date: @params[:min_date], max_date: @params[:max_date])
        .limit(@params[:limit])
        .offset(@params[:offset])
        .order(ordering)

      raise "422 || There is no transaction" unless @transactions.present?

      @csv_results = CSV.generate do |csv|
        csv << ['group', 'wallet', 'user', 'category', 'name', 'amount', 'date', 'description']
        @transactions.each do |transaction|
          csv << [
            transaction.group.name,
            transaction.group_wallet.name,
            transaction.account.username,
            transaction.category,
            transaction.name,
            (transaction.direction_type == 'income' ? transaction.amount : -1 * transaction.amount),
            (transaction.transaction_at+params[:time_zone].hour).strftime("%Y/%m/%d - %H:%M"),
            transaction.description,
          ]
        end
      end
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
      "transaction_at desc, id desc"
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
