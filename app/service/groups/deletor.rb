module Groups
  class Deletor < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:name, :group_id)
    end

    def call
      validates
      execute_logic
      @result = group
    end

    private

    def validates
      group
      return if group.account_id == @account.id
      raise "403 || Forbidden access to group"
    end

    def execute_logic
      group.delete
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
