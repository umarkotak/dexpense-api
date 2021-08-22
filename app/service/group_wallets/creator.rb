module GroupWallets
  class Creator < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:group_id, :name, :wallet_type)
    end

    def call
      validates
      execute_logic
      @result = @group_wallet
    end

    private

    def validates
      return if group.account_id == @account.id
      raise "400 || Invalid group"
    end

    def execute_logic
      @group_wallet = GroupWallet.create!(
        account_id: @account.id,
        group_id: @group.id,
        wallet_type: @params[:wallet_type],
        name: @params[:name],
        amount: 0
      )
    end

    def group
      @group ||= Group.find_by!(params[:group_id])
    end
  end
end
