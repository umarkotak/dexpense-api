class WealthAsset < ApplicationRecord
  validates :name, :amount, :amount_unit, :quantity, :price, :category,
            :sub_category, :transaction_at,
            presence: true
  validates :amount, :price, :quantity,
            numericality: {greater_than_or_equal_to: 0}
  # validates :category,
  #           inclusion: { in: Const::TRANSACTION_CATEGORIES_MAP.keys }

  belongs_to :account
  belongs_to :group
end
