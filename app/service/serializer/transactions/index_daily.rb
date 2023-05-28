module Serializer
  module Transactions
    class IndexDaily
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
          temp_transaction = transaction.attributes.merge({
            icon_url: Const::TRANSACTION_CATEGORIES_MAP[transaction.category][:icon_url],
            account: transaction.account.attributes.except("password", "session"),
            group_wallet: transaction.group_wallet.attributes
          })

          daily_group_time = (temp_transaction["transaction_at"] + params[:time_zone].hour)
          daily_group_date = daily_group_time.to_date
          if !@transactions_map[daily_group_date].present?
            @transactions_map[daily_group_date] = {
              date: daily_group_date,
              day_name: daily_group_date.strftime("%A")[0..2],
              day: daily_group_time.day,
              month: daily_group_time.month,
              year: daily_group_time.year,
              transactions: [],
              income: 0,
              outcome: 0,
              transaction_count: 0
            }
          end

          @transactions_map[daily_group_date][:transaction_count] += 1
          if temp_transaction["direction_type"] == "income" && temp_transaction["category"] != "transfer"
            @transactions_map[daily_group_date][:income] += temp_transaction["amount"]
            range_income += temp_transaction["amount"]
          elsif temp_transaction["category"] != "transfer"
            @transactions_map[daily_group_date][:outcome] += temp_transaction["amount"]
            range_outcome += temp_transaction["amount"]
          end
          @transactions_map[daily_group_date][:transactions] << temp_transaction
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
