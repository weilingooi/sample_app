class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  
  before_save{self.email = email.downcase}
  validates :name, presence: true,
    length: {maximum: Settings.validations.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validations.email.max_length},
    format: {with: Settings.validations.email.regex}
  validates :password, presence: true,
    length: {minimum: Settings.validations.password.min_length}
  has_secure_password
  
  def User.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::min_cost
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
