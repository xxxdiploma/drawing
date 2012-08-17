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
