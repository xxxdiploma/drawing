class Storage < ActiveRecord::Base

  attr_accessible :url, :description, :file_name

  belongs_to :user

  validates :user_id,     :presence => true
  validates :description, :presence => true,
                          :length   => { :maximum => 1000 }
  validates :file_name,   :presence => true,
                          :length   => { :within => 3..120 }
  validates :url,         :presence => true

  default_scope :order => 'storages.created_at DESC'

end
