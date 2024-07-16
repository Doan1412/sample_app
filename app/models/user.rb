class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_ATTRIBUTES = [:name, :email, :password, :password_confirmation].freeze
  mail_regex = Regexp.new(Settings.VALID_EMAIL_REGEX)
  validates :name, presence: true, length: {maximum: Settings.name_max_length}
  validates :email, presence: true,
                    length: {maximum: Settings.email_max_length},
                    format: {with: mail_regex}

  before_save :downcase_email

  has_secure_password

  def downcase_email
    email.downcase!
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticate? remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
