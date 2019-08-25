require 'rails_helper'

feature 'User can choose best answer', "
  In order to point to a more appropriate answer
  As an author a question
  I'd like to be able choose best answer
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
  given!(:reward) { create(:reward, question: question, name: 'reward name', image: image) }
  given!(:answers) { create_list(:answer, 3, user: other_user, question: question) }
  given!(:answer_first) { answers.first }
  given!(:answer_last) { answers.last }

  scenario 'Unauthenticated user can not choose best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can choose best answer for his question', js: true do
      within "#answer-#{answer_last.id}" do
        click_on 'Best'
        sleep(0.5)
      end

      within first('.answer') do
        expect(page).to have_content answer_last.body
        expect(page).to_not have_content answer_first.body
        expect(page).to_not have_link 'Best'
      end
    end

    scenario 'can choose another best answer for his question', js: true do
      answer_first.best!

      within "#answer-#{answer_last.id}" do
        click_on 'Best'
        sleep(0.5)
      end

      within first('.answer') do
        expect(page).to have_content answer_last.body
      end
    end

    scenario "can not choose best answer for other user's question" do
      click_on 'Log out'
      sign_in(other_user)

      expect(page).to_not have_link 'Best'
    end

    scenario 'gets a reward', js: true do
      within "#answer-#{answer_last.id}" do
        click_on 'Best'
        sleep(0.5)
      end

      visit user_rewards_path(answer_last.user)

      expect(page).to have_content question.title
      expect(page).to have_content reward.name
      expect(page).to have_css "img[src*='#{reward.image.filename}']"
    end
  end
end
