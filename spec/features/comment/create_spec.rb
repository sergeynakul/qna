require 'rails_helper'

feature 'User can create comment', "
  In order to share the views
  As user
  I'd like to be able to create comment
" do
  given(:user) { create(:user) }
  given(:question) { create :question }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user tries to create comment for question' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      within '.question' do
        fill_in 'Your comment', with: 'Comment for question'
        click_on 'Create comment'

        expect(page).to have_content 'Comment for question'
      end
      expect(page).to have_content 'Comment successfully created.'
    end

    scenario 'with invalid attributes', js: true do
      within '.question' do
        click_on 'Create comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Authenticated user tries to create comment for answer' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'with valid attributes', js: true do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'Comment for answer'
        click_on 'Create comment'

        expect(page).to have_content 'Comment for answer'
      end
      expect(page).to have_content 'Comment successfully created.'
    end

    scenario 'with invalid attributes', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Create comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'multiple session', js: true do
    scenario "comment for question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Your comment', with: 'Test comment for question'
          click_on 'Create comment'

          expect(page).to have_content 'Test comment for question'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'Test comment for question'
        end
      end
    end

    scenario "comment for answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          fill_in 'Your comment', with: 'Comment for answer'
          click_on 'Create comment'

          expect(page).to have_content 'Comment for answer'
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Comment for answer'
        end
      end
    end
  end
end
