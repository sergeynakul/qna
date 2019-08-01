require 'rails_helper'

feature 'User can destroy question' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)

    visit questions_path
  end

  scenario 'Author tries to delete question', js: true do
    click_on 'Delete'
    expect(page).to_not have_content question.title
  end

  scenario 'Not author tries to delete question' do
    click_on 'Log out'
    sign_in(another_user)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Not authenticated user tries to delete question' do
    click_on 'Log out'

    expect(page).to_not have_link 'Delete'
  end
end
