class AddModeToMonthlyBudgets < ActiveRecord::Migration[6.1]
  def change
    add_column :monthly_budgets, :mode, :string, default: 'generic'
  end
end
