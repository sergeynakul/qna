require 'rails_helper'

feature 'User can create question', "
  In order to receive answer
  as user
  I'd like to be able to create question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user tries to ask a question' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'with valid attributes' do
      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'Test body'
      click_on 'Ask'

      expect(page).to have_content 'Question successfully created.'
      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test body'
    end

    scenario 'with invalid attributes' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
