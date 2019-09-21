FactoryBot.define do
  factory :comment do
    body { 'MyText' }
    user

    trait :invalid do
      body { nil }
    end

    trait :sequences do
      body
    end
  end
end
