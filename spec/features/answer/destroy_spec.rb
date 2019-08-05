require 'rails_helper'

feature 'User can destroy answer' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    sign_in(user)

    visit question_path(question)
  end

  scenario 'Author tries to delete answer', js: true do
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Not author tries to delete answer' do
    click_on 'Log out'
    sign_in(another_user)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Not authenticated user tries to delete answer' do
    click_on 'Log out'

    expect(page).to_not have_link 'Delete answer'
  end
end
