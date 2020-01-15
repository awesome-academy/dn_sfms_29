FactoryBot.define do
  factory :booking do
    user_id {create(:user).id}
    subpitch_id {create(:subpitch).id}
    start_time {Time.now - 2.hour}
    end_time {Time.now - 1.hour}
    status {1}
    total_price {10000}
  end
end
