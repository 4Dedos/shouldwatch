module ApplicationHelper
  def current_user
    if session[:user_id].blank?
      @current_user = User.anonymous
      session[:user_id] = @current_user.id
    else
      @current_user ||= User.find(session[:user_id])
    end

    @current_user
  end
end

