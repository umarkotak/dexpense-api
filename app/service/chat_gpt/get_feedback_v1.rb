require 'csv'

module ChatGpt
  class GetFeedbackV1 < BaseService
    def initialize(account, transactions)
      @account = account
      @transactions = transactions
    end

    def call
      execute_logic
    end

    private

    def execute_logic
      array_of_rows = @transactions.map do |one_transaction|
        {
          category: one_transaction.category,
          amount: one_transaction.amount,
          transaction_at: one_transaction.transaction_at,
          name: one_transaction.name,
          description: one_transaction.description,
        }
      end

      csv_string = array_of_hashes_to_csv_string(array_of_rows)

      prompt_id = "sebagai ahli finansial, tolong berikan tanggapanmu pada data expense yang tercatat pada json berikut ini

      lampiran data json:

      #{array_of_rows.to_json}

      mata uang: rupiah
      "

      prompt_en = "as an expert financial advisor, what do you think of this expense data?

      data:

      #{array_of_rows.to_json}

      currency: Rupiah
      "

      @result = {
        "prompt_id": prompt_id,
        "prompt_en": prompt_en,
        "rows": array_of_rows,
      }
    end

    def array_of_hashes_to_csv_string(array_of_hashes)
      csv_string = CSV.generate(headers: true) do |csv|
        csv << array_of_hashes.first.keys

        array_of_hashes.each do |hash|
          csv << hash.values
        end
      end

      return csv_string
    end
  end
end
