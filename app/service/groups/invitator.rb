module Groups
  class Invitator
    def initialize(account, params)
      @account = account
      @params = params.permit(:username, :group_id)
    end

    def call
      validates
      execute_logic
    end

    private

    def validates
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present? && group_account.role == "owner"
      raise "400 || Invalid group"
    end

    def execute_logic
      GroupAccount.create!(
        account_id: invited_account.id,
        group_id: group.id,
        role: "participant"
      )
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end

    def invited_account
      @invited_account ||= Account.find_by!(username: @params[:username])
    end
  end
end
