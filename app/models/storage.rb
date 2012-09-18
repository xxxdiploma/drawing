class Storage < ActiveRecord::Base

  attr_accessible :url, :title, :description, :file_name, :uid

  belongs_to :user

  validates :user_id,     :presence => true
  validates :file_name,   :presence => true,
                          :length   => { :within => 3..150 }
  validates :url,         :presence => true
  validates :title,       :presence => true,
                          :length   => { :within => 3..150 }
  validates :description, :length   => { :maximum => 1000 }
  validates :uid,         :presence => true

  default_scope :order => 'storages.created_at DESC'

end
