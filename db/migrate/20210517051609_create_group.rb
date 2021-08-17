class CreateGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      
      t.string :name

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
