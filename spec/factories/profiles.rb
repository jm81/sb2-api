FactoryGirl.define do
  factory :profile do
    to_create { |resource| resource.save }

    sequence(:handle) { |n| 'handle%09d' % n }
    display_name 'My Name'
  end
end
