class CreateGroupAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :group_accounts do |t|
      t.references :account
      t.references :group
      t.string :role

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
