FactoryGirl.define do
  factory :profile_member do
    to_create { |resource| resource.save }

    profile
    association :member_user, factory: :user
  end
end
