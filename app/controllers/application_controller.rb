class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :current_site

  def current_site
    @current_site ||= Site.first
  end
  helper_method :current_site

  def preview!
    @preview = true
  end

  def preview?
    @preview
  end
  helper_method :preview?

  def hide_new_arrivals!
    @hide_new_arrivals = true
  end

  def hide_new_arrivals?
    @hide_new_arrivals
  end
  helper_method :hide_new_arrivals?
end
