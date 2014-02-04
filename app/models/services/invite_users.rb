class Services::InviteUsers

  include ActiveModel::Model
  attr_accessor :emails

  validates :emails, presence: true
  #validate :email_format, :unique_emails

  def validate_emails
    user_emails = emails.split(',').map(&:strip).map(&:downcase).delete_if(&:empty?)
    issues = {}
    user_emails.each do |mail|
      a = Services::InviteUser.new(email: mail)
      a.valid?
      issues[mail] = a.errors.messages[:email]
    end
    issues
  end

  #invited by can be used to specify which user as sent the invitation
  def self.invite(invited_by, mails)
    mails.split(',').each do |mail|
      user = User.new(email: mail, role: User::ROLES[1])
      user.invite!
    end
  end

  private

  def unique_emails
    emails.split(',').each{|mail| errors.add(:emails, "email is already taken") unless User.where(email: mail).any? } if emails
    #errors.add(:email, "email is already taken") if User.where(email: email).any?
  end

  def email_format 
    emails.split(',').each{|mail| errors.add(:email, "Invalid email format") unless mail.strip =~ Devise.email_regexp} if emails
  end

end
