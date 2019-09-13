FactoryBot.define do
  factory :question do
    title { 'Question title' }
    body { 'Question body' }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
