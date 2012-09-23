# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  surname            :string(255)      not null
#  initials           :string(255)      not null
#  email              :string(255)      not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#  timezone           :string(255)      default("Moscow")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'digest'

class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :surname, :initials, :email, :password, :password_confirmation, :timezone

  has_many :articles, :dependent => :destroy
  has_many :storages, :dependent => :destroy
  has_many :pictures, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  validates :surname,  :presence     => true,
            					 :length       => { :maximum => 50 }
  validates :initials, :presence     => true,
                       :length       => { :is => 2 }
  validates :email,    :presence     => true,
                       :format       => { :with => email_regex },
                       :uniqueness   => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  validates_inclusion_of :timezone, :in => ActiveSupport::TimeZone.zones_map { |m| m.name }

  before_save :encrypt_password
  before_save :capitalize_initials

  default_scope :order => 'users.id ASC'

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end


  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def capitalize_initials
      self.initials.upcase!
    end
end
