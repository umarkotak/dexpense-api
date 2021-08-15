module Serializer
  module Groups
    class Show
      def initialize(group)
        @group = group
      end

      def call
        @group.attributes.merge(
          group_wallets: group_wallets
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
