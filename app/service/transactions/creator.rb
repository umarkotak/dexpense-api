module Transactions
  class Creator < BaseService
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
      if @params[:direction_type] == "income"
        group_wallet.amount += @params[:amount].to_i
      elsif @params[:direction_type] == "outcome"
        group_wallet.amount -= @params[:amount].to_i
      else
        raise "400 || Invalid direction type`"
      end
      group_wallet.save!
    end

    def transaction_params
      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: @params[:category],
        amount: @params[:amount],
        direction_type: @params[:direction_type],
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
