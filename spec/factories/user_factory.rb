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

FactoryGirl.define do
	factory :user do
  	surname               "Example"
  	initials              "UR"
  	email                 "user@example.com"
  	password              "foobar"
  	password_confirmation "foobar"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end
end
