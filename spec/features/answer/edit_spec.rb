require 'rails_helper'

feature 'User can edit answer', "
  In order to correct mistakes
  As an author a answer
  I'd like to be able edit my answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
