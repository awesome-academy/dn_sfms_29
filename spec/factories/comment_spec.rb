FactoryBot.define do
  factory :comment do
    user_id {"overwrite"}
    rating_id {"overwrite"}
    content {"this is content of comment"}
  end
end
