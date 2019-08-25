require 'rails_helper'

feature 'User can create comment', "
  In order to share the views
  As user
  I'd like to be able to create comment
" do
  given(:user) { create(:user) }
  given(:question) { create :question }
  given(:answer) { create :answer }

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
end
