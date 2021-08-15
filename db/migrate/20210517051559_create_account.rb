class CreateAccount < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :password
      t.string :account_type
      t.string :email
      t.string :session

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
