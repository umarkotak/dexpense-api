class CreateGroupWallet < ActiveRecord::Migration[6.1]
  def change
    create_table :group_wallets do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}
      t.string :name
      t.string :wallet_type
      t.integer :amount

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
