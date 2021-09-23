module Transactions
  class Adjust < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :category, :amount, :direction_type, :group_wallet_id, :name, :description, :note, :transaction_at
      )
    end

    def call
      validates
      execute_logic
      @result = @transaction
    end

    private

    def validates
      allowed_wallet
      @transaction = Transaction.new(transaction_params)
      @transaction.validate!
    end

    def allowed_wallet
      group_account = group_wallet.group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid wallet"
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        @transaction.save!
        process_balance
      end
    end

    def process_balance
      if @transaction.direction_type == "income"
        group_wallet.amount += @transaction.amount.to_i
      elsif @transaction.direction_type == "outcome"
        group_wallet.amount -= @transaction.amount.to_i
      else
        raise "400 || Invalid direction type"
      end
      group_wallet.save!
    end

    def transaction_params
      if @params[:amount] > group_wallet.amount
        amount = @params[:amount] - group_wallet.amount
        direction_type = "income"
      else
        amount = group_wallet.amount - @params[:amount]
        direction_type = "outcome"
      end

      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: "adjustment",
        amount: amount,
        direction_type: direction_type,
        transaction_at: @params[:transaction_at] || Time.now(),
        name: @params[:name],
        description: @params[:description],
        note: @params[:note],
      }
    end

    def group_wallet
      @group_wallet ||= GroupWallet.find(@params[:group_wallet_id])
    end

    def group
      @group ||= group_wallet.group
    end
  end
end
