FactoryBot.define do
  factory :booking do
    user_id {"overwrite"}
    subpitch_id {"overwrite"}
    status {0}
    total_price {20}
    start_time {"2019-01-01 04:00:00 +00:00"}
    end_time {"2019-01-01 05:00:00 +00:00"}
  end
end
