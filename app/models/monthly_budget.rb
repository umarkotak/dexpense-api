class MonthlyBudget < ApplicationRecord
  validates :category,
            inclusion: { in: Const::TRANSACTION_CATEGORIES_MAP.keys }
  validates :mode,
            inclusion: { in: ["generic", "specific"] }
  validates :total_budget,
            numericality: {greater_than_or_equal_to: 0}
  validates :category, presence: true,
            uniqueness: { scope: [:group_id, :mode] },
            if: :mode_is_generic

  belongs_to :account
  belongs_to :group

  def mode_is_generic
    mode == "generic"
  end
end
