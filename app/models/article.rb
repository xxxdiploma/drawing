# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ActiveRecord::Base

  attr_accessible :content

  belongs_to :user

  validates :content, :presence => true,
                      :length => { :maximum => 5000 }
  validates :user_id, :presence => true

  default_scope :order => 'articles.created_at DESC'

end
