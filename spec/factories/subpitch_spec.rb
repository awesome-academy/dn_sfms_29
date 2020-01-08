FactoryBot.define do
  factory :subpitch do
    name {"subpitch name"}
    description {"subpitch description"}
    pitch_id {"overwrite"}
    price_per_hour {20}
    currency {"$"}
    size {5}
    subpitch_type_id {"overwrite"}
  end
end
