require 'rails_helper'

feature 'User can create answer', "
  In order to help someone
  As user
  I'd like to be able to create answer
" do
  given(:user) { create(:user) }
  given(:question) { create :question }

  describe 'Authenticated user tries to create answer' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      fill_in 'Body', with: 'Test answer body'
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer successfully created.'
      within '.answers' do
        expect(page).to have_content 'Test answer body'
      end
    end

    scenario 'with invalid attributes', js: true do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'with attached files', js: true do
      fill_in 'Body', with: 'Test body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multiple session', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Test answer body'
        click_on 'Create answer'

        within '.answers' do
          expect(page).to have_content 'Test answer body'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test answer body'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)
    within '.new-answer' do
      fill_in 'Body', with: 'Test answer body'
      click_on 'Create answer'
    end

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
