class GroupAccount < ApplicationRecord
  validates :role,
            presence: true
  validates :role,
            inclusion: { in: %w(owner assistant participant) }
  validates :account,
            uniqueness: { scope: [:group] }

  belongs_to :account
  belongs_to :group
end
