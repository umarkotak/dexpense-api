module Serializer
  module Accounts
    class Profile
      def initialize(account)
        @account = account
      end

      def call
        @account.attributes.except("session", "password").merge(
          groups: @account.groups,
        )
      end
    end
  end
end
