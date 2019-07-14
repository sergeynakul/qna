FactoryBot.define do
  factory :question do
    title { 'Question title' }
    body { 'Question body' }

    trait :invalid do
      title { nil }
    end
  end
end
