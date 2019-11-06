class ApplicationController < ActionController::Base
  include Clearance::Controller

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |error|
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end

  def not_found
    raise ActionController::RoutingError.new("Not found")
  end
end
