module ApplicationHelper

  def title
    base_title = "MSTU \"Stankin\""
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
  	image_tag("logo_en.png", :alt => "LOGO", :class => "logo")
  end

  def copyright
    "MSTU \"Stankin\" | Department of Engeneering Graphics | #{Time.now.year}"
  end

  def author
    "Created by DY"
  end

end
