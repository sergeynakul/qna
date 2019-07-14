require 'rails_helper'

feature 'User can create answer', "
  In order to help someone
  As user
  I'd like to be able to create answer
" do
  given(:question) { create :question }

  background do
    visit question_path(question)
  end

  scenario 'with valid attributes' do
    fill_in 'Body', with: 'Test answer body'
    click_on 'Create answer'

    expect(page).to have_content 'Answer successfully created.'
    expect(page).to have_content 'Test answer body'
  end

  scenario 'with invalid attributes' do
    click_on 'Create answer'

    expect(page).to have_content "Body can't be blank"
  end
end
