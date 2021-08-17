class Transaction < ApplicationRecord
  TRANSACTION_CATEGORIES = [
    "food",
    "daily_needs",
    "other"
  ].freeze
  
  validates :category, :amount, :direction_type, :name,
            presence: true
  validates :category,
            inclusion: { in: TRANSACTION_CATEGORIES }
  validates :amount,
            numericality: {greater_than_or_equal_to: 0}
  validates :direction,
            inclusion: { in %w(income outcome) }
  
  belongs_to :account
  belongs_to :group
  belongs_to :group_wallet
end
