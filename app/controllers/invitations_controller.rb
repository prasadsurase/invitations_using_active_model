class InvitationsController < Devise::InvitationsController
  before_action :authenticate_user!, except: [:edit, :update]

  def new
    @user = Services::InviteUser.new
  end

  def create
    @user = Services::InviteUser.new(user_params)
    @valid = @user.valid?
    if @valid
      user = User.new(user_params)
      user.invite!
      flash[:notice] = "User #{user.name} invited successfully"
    end
  end
  
  def batch_invite
    @email = Services::InviteUsers.new
  end

  def batch_confirm
    @email = Services::InviteUsers.new users_params
    if @email.valid?
      @issues = @email.validate_emails
    else
      render 'batch_invite' 
    end
  end

  def batch_create
    Services::InviteUsers.invite(current_user, users_params[:emails])
    flash[:success] = "Invitations sent to #{users_params[:emails].split(',').count} users."
    redirect_to root_path 
  end

  private

  def users_params #related to bulk invitations
    params.require(:services_invite_users).permit(:emails)
  end
  
  def user_params #related to single user invitation
    params.require(:services_invite_user).permit(:name, :email)
  end
  
  def company_admin?
    current_user.admin?
  end
end
