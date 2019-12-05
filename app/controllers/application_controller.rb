class ApplicationController < ActionController::Base
  include Clearance::Controller

  helper_method :current_user_notifications

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |error|
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end

  def not_found
    raise ActionController::RoutingError.new("Not found")
  end

  def current_user_notifications
    current_user.notifications
      .includes(:actor)
      .order(created_at: :desc)
      .page(1).per(10)
  end
end
