class GroupWallet < ApplicationRecord
  validates :name, :wallet_type,
            presence: true
  validates :amount,
            numericality: true
  validates :wallet_type,
            inclusion: { in: %w(cash bank credit_card ewallet other) }
  
  belongs_to :account
  belongs_to :group
end
