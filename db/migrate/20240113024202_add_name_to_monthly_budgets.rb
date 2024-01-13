class AddNameToMonthlyBudgets < ActiveRecord::Migration[6.1]
  def change
    add_column :monthly_budgets, :name, :string
  end
end
