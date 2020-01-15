FactoryBot.define do
  factory :subpitch do
    name {Faker::Name.name}
    description {"12341212"}
    pitch_id {create(:pitch).id}
    price_per_hour {10000}
    size {"5 người"}
    subpitch_type_id {create(:subpitch_type).id}
  end
end
