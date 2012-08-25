FactoryGirl.define do
	factory :article do
  	content "Sample text"
  	association :user
  end
end
