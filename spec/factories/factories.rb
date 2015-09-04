FactoryGirl.define do
  factory :user do
    email "test@example.com"
    password "testtest"
    password_confirmation "testtest"
  end

  factory :restaurant do
    name 'KFC'
    user
  end
end
