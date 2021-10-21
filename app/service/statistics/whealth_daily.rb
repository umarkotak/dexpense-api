module Statistics
  class WhealthDaily < BaseService
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
      group_wallets = GroupWallet.where(group_id: group.id)
      balance = 0
      group_wallets.each do |group_wallet|
        balance += group_wallet.amount
      end

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
      @formatted_results = @formatted_results.map do |k, v|
        { name: k.strftime("%Y-%m-%d") }.merge(v)
      end
      @formatted_results = @formatted_results.reverse
      @formatted_results = @formatted_results.map.with_index do |formatted_result, idx|
        if idx == 0
          formatted_result["current_whealth"] = balance
        else
          balance = balance - @formatted_results[idx-1]["income"] + @formatted_results[idx-1]["outcome"]
          formatted_result["current_whealth"] = balance
        end
        formatted_result
      end
      @formatted_results = @formatted_results.reverse
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
