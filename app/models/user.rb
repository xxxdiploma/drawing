class User < ActiveRecord::Base

  attr_accessible :surname, :initials, :email


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  validates :surname,  :presence   => true,
            					 :length     => { :maximum => 50 }
  validates :initials, :presence   => true,
                       :length     => { :maximum => 2 }
  validates :email,    :presence   => true,
                       :format     => { :with => email_regex },
                       :uniqueness => { :case_sensitive => false }
end
