class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w(admin normal)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ##Invitable
  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer

  index( {invitation_token: 1}, {background: true} )
  index( {invitation_by_id: 1}, {background: true} )
  
  field :role, type: String
  field :name, type: String
  
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: ROLES }, presence: true
  
  def admin?
    role == 'admin'
  end

  def normal_user?
    role == 'normal'
  end
end
