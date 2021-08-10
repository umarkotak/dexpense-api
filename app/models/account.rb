class Account < ApplicationRecord
  validates :username, uniqueness: true
end
