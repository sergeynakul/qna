require 'rails_helper'

feature 'User can vote for the question', "
  In order to raise the question rate
  As an authenticated user
  I'd like to be able to vote for the question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(other_user) }

    scenario 'can vote for the question' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario 'cannot vote for his question' do
      click_on 'Log out'
      sign_in(user)

      within "#question-#{question.id}" do
        expect(page).to_not have_content 'Vote up'
        expect(page).to_not have_content 'Vote down'
      end
    end

    scenario 'cannot vote 2 times' do
      within "#question-#{question.id}" do
        click_on 'Vote up'
        click_on 'Vote up'
      end

      expect(page).to have_content "You can't vote twice"
    end

    scenario 'can cancel his decision and then vote' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
        click_on 'Vote down'
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '-1'
      end
    end

    scenario 'can see rating' do
      create_list(:vote, 3, votable: question, user: create(:user))

      within "#question-#{question.id}" do
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '2'
      end
    end
  end

  scenario "Unauthenticated user can't vote for the question" do
    visit questions_path

    expect(page).to_not have_content 'Vote up'
    expect(page).to_not have_content 'Vote down'
  end
end
