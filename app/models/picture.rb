class Picture < ActiveRecord::Base
  attr_accessible :code

  belongs_to :user

  validates :code, :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'pictures.created_at DESC'
end
