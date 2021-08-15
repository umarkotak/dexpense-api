module Serializer
  module Transactions
    class Index
      def initialize(transactions)
        @transactions = transactions
      end

      def call
        @transactions.map do |transaction|
          transaction.attributes
        end
      end
    end
  end
end
