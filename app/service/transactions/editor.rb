module Transactions
  class Editor < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :id, :category, :amount, :direction_type, :group_wallet_id, :name, :description, :note
      )
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
      raise "403 || Not owner of the transaction"
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        revert_balance
        process_balance
        @transaction.update!(@params)
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

    def process_balance
      if @params[:direction_type] == "income"
        group_wallet.amount += @params[:amount]
      elsif @params[:direction_type] == "outcome"
        group_wallet.amount -= @params[:amount]
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
