class CreateTransaction < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}
      t.references :group_wallet, index: true, foreign_key: {on_delete: :cascade}

      t.string :category
      t.integer :amount
      t.string :direction_type
      t.datetime :transaction_at
      t.string :name
      t.string :description
      t.string :note
      t.string :image_url

      t.timestamps
      t.datetime :deleted_at

      t.index :category
      t.index :direction_type
    end
  end
end
