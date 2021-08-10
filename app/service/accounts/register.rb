module Accounts
  class Register < BaseService
    def initialize(params)
      @params = params.permit(
        :name, :password, :password_confirmation, :email
      )
    end

    def call
      create_account
    end

    private

    def create_account
      if params[:password] != params[:password_confirmation]
        errors.add(:base, 'password and password confirmation missmatch')
        return
      end
    end
  end
end
