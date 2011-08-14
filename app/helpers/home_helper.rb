module HomeHelper
  def display_if(bool)
    "display: #{bool ? 'block' : 'none'}"
  end
end

