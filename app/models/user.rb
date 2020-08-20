class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.email.regex
  CREATE_USERS_PARAMS = %i(name email password password_confirmation).freeze
  UPDATE_USERS_PARAMS = %i(name password password_confirmation).freeze
  attr_accessor :remember_token

  before_save{self.email = email.downcase}
  validates :name, presence: true,
    length: {maximum: Settings.validations.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.validations.email.max_length},
    format: {with: Settings.validations.email.regex}
  validates :password, presence: true,
    length: {minimum: Settings.validations.password.min_length},
    allow_nil: true
    
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
