require 'rails_helper'

feature 'User can view' do
  given!(:questions) { create_list(:question, 3) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'all question' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'question and answers for this question' do
    visit question_path(question)

    expect(page).to have_content 'Question title'
    expect(page).to have_content 'Question body'
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
