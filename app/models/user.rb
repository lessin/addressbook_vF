class User < ActiveRecord::Base
  has_secure_password

  has_many :claims

  validates :username,
    uniqueness: true,
    presence: true

  validates :password,
    length: {minimum: 5}

end