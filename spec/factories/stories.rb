FactoryGirl.define do
  factory :story do
    to_create { |resource| resource.save }

    association :author, factory: :profile
    body 'Hello World'
    level 1
    words 2
  end
end
