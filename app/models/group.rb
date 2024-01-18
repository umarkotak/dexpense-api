class Group < ApplicationRecord
  validates :name,
            presence: true

  belongs_to :account
  has_many :group_accounts
  has_many :group_wallets
  has_many :transactions

  def prefill_default
    self.payout_date = 5 unless payout_date.present?
    self.monthly_sallary = 0 unless monthly_sallary.present?
  end
end
