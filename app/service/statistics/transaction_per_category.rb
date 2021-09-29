module Statistics
  class TransactionPerCategory < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :min_time, :max_time, :group_wallet_id, :group_id, :direction_type
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
        t = t.group("category")
        t = t.select(
          "SUM(amount) AS amount," \
          "MAX(category) AS category" \
        )
      end
      @formatted_results = @transactions.map { |transaction| { name: transaction.category, value: transaction.amount } }
    end

    def where_params
      {
        group_id: @params[:group_id],
        group_wallet_id: @params[:group_wallet_id],
        direction_type: @params.fetch(:direction_type, "outcome")
      }.compact
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
