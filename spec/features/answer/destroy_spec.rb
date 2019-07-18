require 'rails_helper'

feature 'User can destroy answer' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create :question }

  background do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'Test answer body'
    click_on 'Create answer'
  end

  scenario 'Author tries to delete answer' do
    expect(page).to have_link 'Delete answer'
  end

  scenario 'Not author tries to delete answer' do
    click_on 'Log out'
    sign_in(another_user)

    expect(page).to_not have_link 'Delete answer'
  end
end
