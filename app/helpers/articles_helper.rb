module ArticlesHelper

  def article_format(text)
    text = Nokogiri::HTML::DocumentFragment.parse(text).to_html
    text = sanitize(text)
    text.html_safe
  end

end
