FactoryBot.define do
  factory :recharge do
    sender_id {create(:user, role: 0).id}
    receiver_id {create(:user).id}
    money {10000}
  end
end
