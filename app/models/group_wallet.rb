class GroupWallet < ApplicationRecord
  validates :name, :wallet_type,
            presence: true
  validates :amount,
            numericality: true
  
  belongs_to :account
  belongs_to :group
end
