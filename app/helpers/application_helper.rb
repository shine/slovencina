# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_success_color number
    if number < 0.5 
      'red'
    elsif (number >= 0.5 && number < 0.95) 
      'yellow'
    elsif number >= 0.95 
      'green'
    end
  end
end
