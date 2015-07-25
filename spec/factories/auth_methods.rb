FactoryGirl.define do
  factory :auth_method do
    to_create { |resource| resource.save }

    user
    provider :test
    provider_id 1
  end
end
