module Auth
  class Authenticator < BaseService
    def initialize(session)
      @session = session
    end

    def call
      account = Account.find_by(session: @session)
      return @result = account if account.present?
      raise "401 || Unauthorized"
    end
  end
end
