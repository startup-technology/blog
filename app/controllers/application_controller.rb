class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_site
  before_action :require_login

  private

  def render_not_found_error(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render file: "#{Rails.root}/public/404.html", status: 404, content_type: 'text/html', layout: false
  end

  def require_site
    render_not_found_error if current_site.blank?
  end

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

  def categories
    @categories ||= Category.all
  end
  helper_method :categories

  def new_arrival_articles
    @new_arrival_articles ||= Article.new_arrivals.limit(3)
  end
  helper_method :new_arrival_articles
end
