class CreateGroupAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :group_accounts do |t|
      t.references :account, foreign_key: true
      t.references :group, foreign_key: true
      t.string :role

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
