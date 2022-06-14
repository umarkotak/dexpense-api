class Transaction < ApplicationRecord
  validates :category, :amount, :direction_type, :name,
            presence: true
  validates :category,
            inclusion: { in: Const::TRANSACTION_CATEGORIES_MAP.keys }
  validates :amount,
            numericality: {greater_than_or_equal_to: 0}
  validates :direction_type,
            inclusion: { in: %w(income outcome) }

  belongs_to :account
  belongs_to :group
  belongs_to :group_wallet
end
