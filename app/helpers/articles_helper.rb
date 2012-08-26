module ArticlesHelper

  def posted_by_at(article)
    posted_by = t('.posted_by')
    user = user_full_name(User.find(article.user_id))
    posted_at = t('.at')

    Time.zone = "Moscow" #Переписать потом
    time = article.created_at.in_time_zone.to_s(:russian)

    posted_by + " " + user + " " + posted_at + " " + time
  end

end
