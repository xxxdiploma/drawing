module ArticlesHelper

  def article_by(article)
    user_full_name(User.find(article.user_id))
  end

  def article_author(article)
    return User.find(article.user_id)
  end

  def article_time(article)
    Time.zone = "Moscow" #Переписать потом

    article.created_at.in_time_zone.to_s(:russian)
  end

  def article_format(text)
    text = Nokogiri::HTML::DocumentFragment.parse(text).to_html
    text = sanitize(text)
    text.html_safe
  end

end
