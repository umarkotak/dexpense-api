module Transactions
  class Creator < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :category, :amount, :direction_type, :group_wallet_id, :name, :description, :note
      )
    end

    def call
      validates
      execute_logic
      @result = @transaction
    end

    private

    def validates
      @transaction = Transaction.new(transaction_params)
      @transaction.validate!
    end

    def execute_logic
      @transaction.save!
    end

    def transaction_params
      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: @params[:category],
        amount: @params[:amount],
        direction_type: @params[:direction_type],
        transaction_at: Time.now(),
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
