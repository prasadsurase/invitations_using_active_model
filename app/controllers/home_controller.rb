class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @user = Services::InviteUser.new
  end
end
