FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    title
    body { 'Question body' }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
