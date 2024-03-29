class Account < ApplicationRecord
  validates :username,
            uniqueness: true
  validates :username, :password, :email,
            presence: true
  validates :account_type,
            inclusion: { in: %w(default admin vip) }

  has_many :group_accounts
  has_many :group_wallets
  has_many :transactions
  has_many :groups, through: :group_accounts
end
