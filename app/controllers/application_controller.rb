class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || dashboard_root_path
  end
end
