class MonthlyBudget < ApplicationRecord
  validates :category,
            inclusion: { in: Transaction::TRANSACTION_CATEGORIES }
  validates :total_budget,
            numericality: {greater_than_or_equal_to: 0}

  belongs_to :account
  belongs_to :group
end

# MonthlyBudget.create!(
#   account_id: 1,
#   group_id: 1,
#   category: 'food',
#   total_budget: 1000000
# )