class CreateGroupAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :group_accounts do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}
      t.string :role

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
