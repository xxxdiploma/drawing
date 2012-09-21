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

FactoryGirl.define do
	factory :storage do
  	url           "http://file.test"
  	title         "test file"
  	description   "description"
  	file_name     "test.txt"
    
    association :user
  end
end
