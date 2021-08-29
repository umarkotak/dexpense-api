module Serializer
  module Groups
    class Index
      def initialize(groups)
        @groups = groups
      end

      def call
        @groups.map do |group|
          group.attributes.merge(
            group_wallets: group_wallets(group),
            accounts: accounts(group)
          )
        end
      end

      private

      def group_wallets(group)
        group.group_wallets.map do |group_wallet|
          group_wallet.attributes
        end
      end

      def accounts(group)
        group.group_accounts.map do |group_account|
          group_account.account.attributes.except("password", "session")
        end
      end
    end
  end
end
