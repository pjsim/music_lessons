class UsersController < ApplicationController
  before_filter :authenticate_user!
  Rails.logger.info("Client ID: #{ENV['OAUTH_CLIENT_ID']}")
Rails.logger.info("Secrete key: #{ENV['OAUTH_CLIENT_SECRET']}")


  def calendar
    @events = Event.all
  end


  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    if params[:tag]
      @user = User.tagged_with(params[:tag])
      # @events = @user.events
      @events = Event.all
    else
      @user = User.find(params[:id])
      @events = Event.all
    end
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end