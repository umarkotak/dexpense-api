class CreateGroupAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :group_accounts do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}
      t.string :role

      t.timestamps
      t.datetime :deleted_at

      t.index [:account_id, :group_id], unique: true
    end
  end
end
