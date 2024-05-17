class User < ApplicationRecord
    
    has_secure_password

    validates :name, presence: true
    validates :username, uniqueness: { case_sensitive: false }, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :password, length: { minimum: 8 }
end
