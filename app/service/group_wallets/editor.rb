module GroupWallets
  class Editor < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:id, :name, :wallet_type)
      @group_wallet_id = @params.delete(:id)
    end

    def call
      validates
      execute_logic
      @result = @group_wallet
    end

    private

    def validates
      group_wallet
      return if group_wallet.account_id == @account.id
      raise "400 || Invalid group wallet"
    end

    def execute_logic
      group_wallet.update!(
        wallet_type: @params[:wallet_type],
        name: @params[:name]
      )
    end

    def group_wallet
      @group_wallet ||= GroupWallet.find(@group_wallet_id)
    end
  end
end
