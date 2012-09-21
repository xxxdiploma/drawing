FactoryGirl.define do
	factory :storage do
  	url           "http://file.test"
  	title         "test file"
  	description   "description"
  	file_name     "test.txt"
    
    association :user
  end
end
