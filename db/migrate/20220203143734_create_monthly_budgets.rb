class CreateMonthlyBudgets < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_budgets do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}

      t.string :category
      t.integer :total_budget

      t.timestamps
      t.datetime :deleted_at

      t.index :category
    end
  end
end
