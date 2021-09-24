module Statistics
  class TransactionDaily < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :min_time, :max_time, :category, :group_wallet_id, :group_id
      )
    end

    def call
      validates
      execute_logic
      @result = @formatted_results
    end

    private

    def validates
      raise "400 || Missing group" unless group.present?
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid group"
    end

    def execute_logic
      @transactions = begin
        t = Transaction
        t = t.where(where_params)
        t = t.where("transaction_at >= ?", @params[:min_time]) if @params[:min_time].present?
        t = t.where("transaction_at < ?", @params[:max_time]) if @params[:max_time].present?
        t = t.limit(@params[:limit])
        t = t.offset(@params[:offset])
        t = t.order(ordering)
        t = t.group("DATE(transaction_at + INTERVAL '7' HOUR), direction_type")
        t = t.select(
          "SUM(amount) AS amount," \
          "MAX(DATE(transaction_at + INTERVAL '7' HOUR)) AS transaction_at," \
          "MAX(direction_type) AS direction_type" \
        )
      end

      @formatted_results = {}
      @transactions.each do |transaction|
        if @formatted_results[transaction.transaction_at]
          @formatted_results[transaction.transaction_at][transaction.direction_type] = transaction.amount
        else
          @formatted_results[transaction.transaction_at] = {
            "income" => 0, "outcome" => 0
          }
          @formatted_results[transaction.transaction_at][transaction.direction_type] = transaction.amount
        end
      end
      @formatted_results = @formatted_results.map { |k, v| { name: k.strftime("%Y-%m-%d") }.merge(v) }
    end

    def where_params
      {
        group_id: @params[:group_id],
        group_wallet_id: @params[:group_wallet_id],
        category: @params[:category]
      }.compact
    end

    def ordering
      Arel.sql("MAX(DATE(transaction_at)) ASC")
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
