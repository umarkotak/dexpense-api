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
      validate_create_account
    end

    def validate_create_account
      if params[:password] != params[:password_confirmation]
        raise '400 || password and password confirmation missmatch'
      end
    end

    def execute_logic
      account = Account.create!(
        username: @params[:username],
        email: @params[:email],
        password: @params[:password]
      )
    end

    def result_data
      { username: @params[:username], email: @params[:email] }
    end
  end
end
