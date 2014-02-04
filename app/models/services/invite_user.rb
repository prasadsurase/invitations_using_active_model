class Services::InviteUser
  include ActiveModel::Model
  
  attr_accessor :name, :email

  validates :email, format: {with: Devise.email_regexp, message: "Invalid email format"}, presence: {message: "email not specified"} 
  validate :email_is_unique
  
  private

  def email_is_unique
    errors.add(:email, "email is already taken") if User.where(email: email).any?
  end
end
