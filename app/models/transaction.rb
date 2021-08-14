class Transaction < ApplicationRecord
  validates :category, :amount, :direction_type,
            presence: true
end
