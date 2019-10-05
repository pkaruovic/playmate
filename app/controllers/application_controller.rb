class ApplicationController < ActionController::Base
  include Clearance::Controller

  rescue_from ActiveRecord::RecordNotFound do |error|
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
