module Accounts
  class Register < BaseService
    def initialize(params)
      @params = params.permit(
        :username, :password, :password_confirmation, :email
      )
    end

    def call
      validates
      execute_logic
      @result = result_data
    end

    private

    def validates
      validate_password_confirmation
    end

    def validate_password_confirmation
      if params[:password] != params[:password_confirmation]
        raise "400 || password and password confirmation missmatch"
      end
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        account = Account.create!(
          username: @params[:username],
          email: @params[:email],
          password: @params[:password],
          account_type: "default"
        )
        group = Group.create!(
          account_id: account.id,
          name: "personal"
        )
        group_account = GroupAccount.create!(
          account_id: account.id,
          group_id: group.id,
          role: "owner"
        )
        group_wallet = GroupWallet.create!(
          account_id: account.id,
          group_id: group.id,
          name: "my wallet",
          wallet_type: "cash",
          amount: 0
        )
      end
    end

    def result_data
      { username: @params[:username], email: @params[:email] }
    end
  end
end
