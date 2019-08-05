require 'rails_helper'

feature 'User can edit question', "
  In order to correct mistakes
  As an author a question
  I'd like to be able edit my question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path

      click_on 'Edit'
    end

    scenario 'edits his question', js: true do
      fill_in 'Title', with: 'edited title'
      fill_in 'Body', with: 'edited body'
      click_on 'Ask'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits his question with errors', js: true do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in(other_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
