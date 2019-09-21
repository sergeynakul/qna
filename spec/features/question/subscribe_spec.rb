require 'rails_helper'

feature 'User can subscribe on/unsubscribe form question', "
  In order to follow/unfollow question
  As an authenticated user
  I'd like to be able to follow/unfollow question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not subscribe/unsubscribe' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe')
    expect(page).to_not have_link('Unsubscribe')
  end

  describe 'Authenticated user', js: true do
    scenario 'can unsubscribe form question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link('Unsubscribe')

      click_on 'Unsubscribe'

      expect(page).to have_link('Subscribe')
      expect(page).to_not have_link('Unsubscribe')
    end

    scenario 'can subscribe on question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link('Unsubscribe')
      expect(page).to have_link('Subscribe')

      click_on 'Subscribe'

      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link('Unsubscribe')
    end
  end
end
