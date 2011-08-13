module ApplicationHelper
  def current_user
    @current_user ||= session[:user_id].blank? ? User.anonymous : User.find(session[:user_id])
  end
end

