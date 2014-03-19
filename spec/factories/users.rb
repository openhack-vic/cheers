# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    password '123456password'
    name 'Cave Johnson'
    sequence(:email) { |n| "test#{n}@example.com" }

  end
end
