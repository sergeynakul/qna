require 'rails_helper'

feature 'User can view' do
  scenario 'all question' do
    create_list(:question, 3)

    visit questions_path

    expect(page).to have_content('Question title', count: 3)
    expect(page).to have_content('Question body', count: 3)
  end

  scenario 'question and answers for this question' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)

    visit question_path(question)

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
