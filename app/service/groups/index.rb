module Groups
  class Index < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:group_id)
    end

    def call
      validates
      execute_logic
      @result = @groups
    end

    private

    def validates
    end

    def execute_logic
      @groups = @account.groups.preload(:group_wallets, group_accounts: :account).all
    end
  end
end
