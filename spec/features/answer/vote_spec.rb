require 'rails_helper'

feature 'User can vote for the answer', "
  In order to raise the answer rate
  As an authenticated user
  I'd like to be able to vote for the answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: other_user, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote for the answer' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario 'cannot vote for his answer' do
      click_on 'Log out'
      sign_in(other_user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Vote up'
        expect(page).to_not have_content 'Vote down'
      end
    end

    scenario 'cannot vote 2 times' do
      within "#answer-#{answer.id}" do
        click_on 'Vote up'
        click_on 'Vote up'
      end

      expect(page).to have_content "You can't vote twice"
    end

    scenario 'can cancel his decision and then vote' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
        click_on 'Vote down'
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '-1'
      end
    end

    scenario 'can see rating' do
      create_list(:vote, 3, votable: answer, user: create(:user))

      within "#answer-#{answer.id}" do
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '2'
      end
    end
  end

  scenario "Unauthenticated user can't vote for the answer" do
    visit question_path(question)

    expect(page).to_not have_content 'Vote up'
    expect(page).to_not have_content 'Vote down'
  end
end
