FactoryBot.define do
  factory :pitch do
    name {"pitch name"}
    description {"pitch description"}
    country {"country name"}
    city {"city name"}
    district {"district name"}
    address {"address"}
    phone {"0123456789"}
    start_time {"04:00:00 +07:00"}
    end_time {"17:00:00 +07:00"}
    limit {1}
    user_id {create(:user).id}
  end
end
