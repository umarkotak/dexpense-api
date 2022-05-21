module Accounts
  class Login < BaseService
    def initialize(params)
      @params = params.permit(
        :username, :password
      )
    end

    def call
      validates
      execute_logic
      @result = result_data
    end

    private

    def validates
      return if params[:username].present? && params[:password].present?
      raise "400 || username or password is missing"
    end

    def execute_logic
      @account = Account.find_by(username: params[:username], password: params[:password])
      raise "400 || invalid username or password" unless @account.present?

      if @account.session.present?
        @account.session
      else
        @account.update!(session: "Bearer #{SecureRandom.uuid}-#{SecureRandom.uuid}")
      end
    end

    def result_data
      {
        session: @account.session,
        username: @account.username
      }
    end
  end
end
