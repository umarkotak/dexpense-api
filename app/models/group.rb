class Group < ApplicationRecord
  validates :name,
            presence: true
  
  has_many :group_accounts
  has_many :group_wallets
  has_many :transactions
end
