class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validations.email.regex
  CREATE_USERS_PARAMS = %i(name email password password_confirmation).freeze
  UPDATE_USERS_PARAMS = %i(name password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  def send_mail_reset_password
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
                      reset_sent_at: Time.zone.now
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
