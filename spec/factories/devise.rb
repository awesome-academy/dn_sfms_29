FactoryBot.define do
  factory :user do
    full_name {"hellomn"}
    email {Faker::Internet.email}
    password {"qwerty"}
    password_confirmation {"qwerty"}
    confirmed_at {Time.now}
  end
end
