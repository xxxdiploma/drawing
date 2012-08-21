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

end
