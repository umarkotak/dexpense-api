class CreateGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
