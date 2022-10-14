class CreateWealthAsset < ActiveRecord::Migration[6.1]
  def change
    create_table :wealth_assets do |t|
      t.references :account, index: true, foreign_key: {on_delete: :cascade}
      t.references :group, index: true, foreign_key: {on_delete: :cascade}

      t.string :name
      t.string :description
      t.string :sub_description
      t.integer :amount
      t.string :amount_unit
      t.integer :quantity
      t.integer :price
      t.string :category
      t.string :sub_category
      t.datetime :transaction_at

      t.boolean :for_sale
      t.integer :sell_price
      t.boolean :cod_only
      t.string :cod_place
      t.string :cod_place_description

      t.timestamps
      t.datetime :deleted_at

      t.index :category
    end
  end
end
