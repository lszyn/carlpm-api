class User < ApplicationRecord
  has_secure_password

  has_many :projects

  validates :email, :password_digest, presence: true
end
