# == Schema Information
#
# Table name: storages
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  file_name   :string(255)      not null
#  url         :string(255)      not null
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Storage < ActiveRecord::Base

  attr_accessible :url, :title, :description, :file_name

  belongs_to :user

  validates :user_id,     :presence => true
  validates :file_name,   :presence => true,
                          :length   => { :within => 3..150 }
  validates :url,         :presence => true
  validates :title,       :presence => true,
                          :length   => { :within => 3..150 }
  validates :description, :length   => { :maximum => 1000 }

  default_scope :order => 'storages.created_at DESC'

end
