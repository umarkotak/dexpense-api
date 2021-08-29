module Groups
  class Remover
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
      validate_ownership
      validate_removal_account
    end

    def validate_ownership
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present? && group_account.role == "owner"
      raise "400 || Invalid group"
    end

    def validate_removal_account
      return if @account.id != removed_account.id
      raise "400 || Cannot remove self"
    end

    def execute_logic
      group.group_accounts.find_by(account_id: removed_account.id).delete
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end

    def removed_account
      @removed_account ||= Account.find_by!(username: @params[:username])
    end
  end
end
