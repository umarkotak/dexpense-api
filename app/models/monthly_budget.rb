class MonthlyBudget < ApplicationRecord
  validates :category,
            inclusion: { in: Const::TRANSACTION_CATEGORIES_MAP.keys }
  validates :total_budget,
            numericality: {greater_than_or_equal_to: 0}
  validates :category, presence: true, uniqueness: { scope: :group_id }

  belongs_to :account
  belongs_to :group
end
