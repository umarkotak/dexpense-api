module Serializer
  module Transactions
    class IndexMonthly
      attr_reader :params

      def initialize(params, transactions)
        @params = params
        @transactions = transactions
        @transactions_map = {}
        @final_transactions = []
      end

      def call
        range_income = 0
        range_outcome = 0
        range_total = 0

        @transactions.each do |transaction|
          temp_transaction = transaction
          daily_group_time = temp_transaction.transaction_at_month
          daily_group_date = daily_group_time.to_date
          if !@transactions_map[daily_group_date].present?
            @transactions_map[daily_group_date] = {
              date: daily_group_date,
              day_name: daily_group_date.strftime("%A")[0..2],
              day: daily_group_time.day,
              month: daily_group_time.month,
              year: daily_group_time.year,
              income: 0,
              outcome: 0,
            }
          end

          if temp_transaction["direction_type"] == "income"
            @transactions_map[daily_group_date][:income] += temp_transaction["amount"]
            range_income += temp_transaction["amount"]
          else
            @transactions_map[daily_group_date][:outcome] += temp_transaction["amount"]
            range_outcome += temp_transaction["amount"]
          end
        end
        @final_transactions = {
          groupped_transactions: @transactions_map.keys.map do |key|
            @transactions_map[key]
          end,
          income: range_income,
          outcome: range_outcome,
          total: range_income - range_outcome
        }
      end
    end
  end
end
