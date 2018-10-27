class Admin::RootController < ApplicationController
  layout 'login'

  skip_before_action :require_site
  skip_before_action :require_login

  before_action -> { redirect_to admin_login_identifier_url if current_site.present? }

  def index
    redirect_to admin_new_url
  end

  def new
    @site = Site.new
    @user = User.new
  end

  def create
    @site = Site.new(site_params)
    @user = User.new(user_params)

    if @site.valid? & @user.valid?
      User.transaction do
        @site.save!
        @user.admin!
      end

      auto_login(@user)

      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  private

  def site_params
    params.require(:site).permit(
      SitePolicy.new(User.new(role: :admin), :site).permitted_attributes
    )
  end

  def user_params
    params.require(:user).permit(
      UserPolicy.new(User.new(role: :admin), :user).permitted_attributes
    )
  end
end
