class User < ApplicationRecord
    has_secure_password
    validates :name, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :password, length: { minimum: 6 }
end