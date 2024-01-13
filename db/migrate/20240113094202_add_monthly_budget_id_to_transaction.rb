class AddMonthlyBudgetIdToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :monthly_budget, index: true, foreign_key: true
  end
end
