class CreateGroupWallet < ActiveRecord::Migration[6.1]
  def change
    create_table :group_wallets do |t|
      t.references :accounts
      t.references :groups
      t.string :name
      t.string :type
      t.integer :amount

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
