FactoryBot.define do
  factory :user do
    email {"#{Faker::Internet.email}"}
    full_name {"#{Faker::Name.name}"}
    password {"#{Faker::String.random(length: 6..12)}"}
    role {2}
    activated {false}
    activated_at {nil}
  end
end
