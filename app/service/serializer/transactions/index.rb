module Serializer
  module Transactions
    class Index
      def initialize(transactions)
        @transactions = transactions
      end

      def call
        @transactions.map do |transaction|
          transaction.attributes.merge({
            account: transaction.account.attributes.except("password", "session"),
            group_wallet: transaction.group_wallet.attributes
          })
        end
      end
    end
  end
end
