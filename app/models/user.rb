class User < ApplicationRecord
  has_secure_password

  validates :handle, presence: true, uniqueness: true
  validates :name, presence: true
end
