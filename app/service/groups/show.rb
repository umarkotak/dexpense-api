module Groups
  class Show < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:group_id)
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
      @group = Group.preload(:group_wallets).find(@params[:group_id])
      @group.prefill_default
    end
  end
end
