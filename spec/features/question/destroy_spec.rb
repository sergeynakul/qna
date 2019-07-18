require 'rails_helper'

feature 'User can destroy question' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }

  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'
    click_on 'Ask'
  end

  scenario 'Author tries to delete quesion' do
    click_on 'Delete question'
    expect(page).to_not have_content 'Test title'
  end

  scenario 'Not author tries to delete quesion' do
    click_on 'Log out'
    sign_in(another_user)

    expect(page).to_not have_link 'Delete question'
  end
end
