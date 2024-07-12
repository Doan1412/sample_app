class User < ApplicationRecord
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

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost
    end
  end
end
