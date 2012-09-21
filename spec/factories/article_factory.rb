# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
	factory :article do
  	content "Sample text"
  	association :user
  end
end
