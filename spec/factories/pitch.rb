FactoryBot.define do
  factory :pitch do
    user_id {create(:user).id}
    name {Faker::Name.name}
    country {Faker::Address.country}
    city {Faker::Address.city}
    district {"Hai chau"}
    address {Faker::Address.full_address}
    phone {9052841111}
    start_time {Time.now - 2.hour}
    end_time {Time.now}
    limit {2}
  end
end
