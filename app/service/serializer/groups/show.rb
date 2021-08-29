module Serializer
  module Groups
    class Show
      def initialize(group)
        @group = group
      end

      def call
        @group.attributes.merge(
          group_wallets: group_wallets,
          account: @group.account.attributes.except("password", "session")
        )
      end

      private

      def group_wallets
        @group.group_wallets.map do |group_wallet|
          group_wallet.attributes
        end
      end
    end
  end
end
