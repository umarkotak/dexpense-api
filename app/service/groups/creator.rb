module Groups
  class Creator < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:name)
    end

    def call
      validates
      execute_logic
      @result = @group
    end

    private

    def validates
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        @group = Group.create!(
          account_id: @account.id,
          name: @params[:name]
        )
        group_account = GroupAccount.create!(
          account_id: @account.id,
          group_id: @group.id,
          role: "owner"
        )
        group_wallet = GroupWallet.create!(
          account_id: @account.id,
          group_id: @group.id,
          name: "default",
          wallet_type: "cash",
          amount: 0
        )
      end
    end
  end
end
