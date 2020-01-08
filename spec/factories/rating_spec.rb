FactoryBot.define do
  factory :rating do
    user_id {"overwrite"}
    booking_id {"overwrite"}
    star {5}
    content {"this is content of rating"}
  end
end
