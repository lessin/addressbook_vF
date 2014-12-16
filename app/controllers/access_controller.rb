class AccessController < ApplicationController

  before_action :confirm_logged_in, except: [:new, :create, :attempt_login, :login, :logout, :payrequest, :paysubmit]
  before_action :prevent_login_signup, only: [:login, :new]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if(@user.save)
      session[:user_id] = @user.id
      session[:admin] = @user.admin
      flash[:success] = "You are now logged in!"
      redirect_to claims_path
    else
      render :new
    end
  end

  def login
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if !found_user
      flash.now[:alert] = "Invalid username"
      render :login
    elsif !authorized_user
      flash.now[:alert] = "Invalid password"
      render :login
    else
      session[:user_id] = authorized_user.id
      session[:admin] = authorized_user.admin
      flash[:success] = "You are now logged in."
      redirect_to claims_path
    end

  end

  def logout
    # mark user as logged out
    session[:user_id] = nil
    session[:admin] = nil
    flash[:notice] = "Logged out"
    redirect_to login_path
  end


  ####################

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

end