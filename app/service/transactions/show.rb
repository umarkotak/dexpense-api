module Transactions
  class Show < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:id)
    end

    def call
      validates
      execute_logic
      @result = @transaction
    end

    private

    def validates
      return if transaction.group.group_accounts.find_by(account_id: @account.id).present?
      raise "400 || Invalid group"
    end

    def execute_logic
      @transaction = Transaction.preload(:account, :group).find(@params[:id])
    end

    def transaction
      @transaction ||= Transaction.find(@params[:id])
    end
  end
end
