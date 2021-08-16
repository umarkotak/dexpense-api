class CreateGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.references :account, foreign_key: true
      
      t.string :name

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
