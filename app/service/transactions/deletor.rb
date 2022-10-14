module Transactions
  class Deletor < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:id)
      @transaction_id = @params.delete(:id)
    end

    def call
      validates
      execute_logic
      @result = @transaction
    end

    private

    def validates
      transaction
      return if transaction.account_id == @account.id
      return if GroupAccount.find_by(
        account_id: @account.id, group_id: group_wallet.group_id
      ).present?
      raise "403 || Not owner of the transaction"
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        revert_balance
        @transaction.delete
      end
    end

    def revert_balance
      if transaction.direction_type == "income"
        group_wallet.amount -= transaction.amount
      elsif transaction.direction_type == "outcome"
        group_wallet.amount += transaction.amount
      else
        raise "400 || Invalid direction type`"
      end
      group_wallet.save!
    end

    def transaction
      @transaction ||= Transaction.find(@transaction_id)
    end

    def group_wallet
      @group_wallet ||= transaction.group_wallet
    end
  end
end
