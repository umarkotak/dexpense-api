class CreateTransaction < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :accounts
      t.references :groups
      t.references :group_wallets

      t.string :category
      t.integer :amount
      t.string :direction_type
      t.datetime :transaction_at
      t.string :name
      t.string :description
      t.string :note

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
