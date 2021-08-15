class Transaction < ApplicationRecord
  TRANSACTION_CATEGORIES = [
    "food",
    "daily needs",
    "other"
  ].freeze
  
  validates :category, :amount, :direction_type, :name,
            presence: true
  validates :category,
            inclusion: { in: TRANSACTION_CATEGORIES }
  
  belongs_to :account
  belongs_to :group
  belongs_to :group_wallet
end
