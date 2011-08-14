module HomeHelper
  def display_if(bool)
    "display: #{bool ? 'block' : 'none'}"
  end

  def recommended_by(user)
    link_to "(from @#{user})", "/#{user}"
  end

  def recommended_to(user)
    link_to "(to @#{user})", "/#{user}"
  end
end

