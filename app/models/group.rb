class Group < ApplicationRecord
  validates :name,
            presence: true
  
  belongs_to :account
  has_many :group_accounts
  has_many :group_wallets
  has_many :transactions
end
