class UsersController < ApplicationController
  layout 'account'
  skip_before_filter :authenticate_user!,
    :only => [:new, :create]

  def new
    @user = User.new
  end

  # Uncomment this to use "Identity"
  #def edit
  #  @user = current_user
  #end

  def create
    @user = User.new(params[:user])

    verify_recaptcha and @user.captcha_checked!

    if @user.save
      session[:current_user_id] = @user.id
      redirect_to account_path, :notice => (t :account_created)
    else
      render :action => :new
    end
  end

  # Uncomment this to use "Identity"
  #def update
  #  @user = current_user

  #  params[:user].delete(:full_name) unless @user.full_name.blank?
  #  params[:user].delete(:address) unless @user.address.blank?
    
  #  if @user.update_attributes(params[:user])
  #    redirect_to edit_user_path,
  #      :notice => (t :account_updated)
  #  else
  #    render :action => :edit
  #  end
  #end

end
