module ArticlesHelper

  def article_by(article)
    user_full_name(User.find(article.user_id))
  end

  def article_author(article)
    return User.find(article.user_id)
  end

  def article_time(article)
    Time.zone = "Moscow" #Переписать потом

    current_time = article.created_at

    old = Russian::strftime(current_time, "%d %b %Y")
    normal =  Russian::strftime(current_time, "%d %b %H:%M")

    current_time.to_i < 1.year.ago.to_i ? old : normal
  end

  def article_format(text)
    text = Nokogiri::HTML::DocumentFragment.parse(text).to_html
    text = sanitize(text)
    text.html_safe
  end

end
