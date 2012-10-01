module UsersHelper
  def picture_name(picture)
    "#{t('.drawing')} #{picture.id} / #{post_time(picture)}"
  end

  def pictures_title
    "#{@pictures.count} " + t(".drawings", :count => @pictures.count)
  end
end
