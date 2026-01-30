FactoryBot.define do
  factory :task do
    description { Faker::Lorem.sentence }
  end
end
