require 'rails_helper'

feature 'User can create answer', "
  In order to help someone
  As user
  I'd like to be able to create answer
" do
  given(:user) { create(:user) }
  given(:question) { create :question }

  describe 'Authenticated user tries to create answer' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      fill_in 'Body', with: 'Test answer body'
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer successfully created.'
      within '.answers' do
        expect(page).to have_content 'Test answer body'
      end
    end

    scenario 'with invalid attributes', js: true do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Test answer body'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end