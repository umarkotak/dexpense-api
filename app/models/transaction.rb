class Transaction < ApplicationRecord
  TRANSACTION_CATEGORIES = [
    "food",
    "daily_needs",
    "social_life",
    "self_development",
    "transportation",
    "household",
    "apparel",
    "beauty",
    "health",
    "education",
    "gift",
    "infaq",
    "admin_fee",

    "allowance",
    "salary",
    "petty_cash",
    "bonus",
    
    "other"
  ].freeze

  validates :category, :amount, :direction_type, :name,
            presence: true
  validates :category,
            inclusion: { in: TRANSACTION_CATEGORIES }
  validates :amount,
            numericality: {greater_than_or_equal_to: 0}
  validates :direction_type,
            inclusion: { in: %w(income outcome) }

  belongs_to :account
  belongs_to :group
  belongs_to :group_wallet
end
