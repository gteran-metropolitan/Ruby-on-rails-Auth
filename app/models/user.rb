class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  before_create :set_default_verification

  private

  def set_default_verification
    self.email_verified = false
    self.verification_code = generate_verification_code
  end

  def generate_verification_code
    SecureRandom.random_number(100_000..999_999).to_s
  end
end
