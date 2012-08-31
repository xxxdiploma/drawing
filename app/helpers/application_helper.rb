module ApplicationHelper

  def title
    base_title = t('titles.base')
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    locale = I18n.locale.to_s
  	image_tag("logo_#{locale}.png", :alt => "LOGO", :class => "logo")
  end

  def copyright
    "#{t('copyright')} | #{Time.now.year}"
  end

  def author
    t('author')
  end

  def contact_page?
    request.path == contact_path
  end

  def user_full_name(user)
    "#{user.surname} #{user.initials.first}. #{user.initials.last}."
  end

  def include_google_maps
    content_for :google_maps do
      javascript_include_tag "http://maps.googleapis.com/maps/api/js?&sensor=false"
    end
  end

end
