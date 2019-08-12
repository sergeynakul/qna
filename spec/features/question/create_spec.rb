require 'rails_helper'

feature 'User can create question', "
  In order to receive answer
  as user
  I'd like to be able to create question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user tries to ask a question' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'Test body'
    end

    scenario 'with valid attributes' do
      click_on 'Ask'

      expect(page).to have_content 'Question successfully created.'
      expect(page).to have_content 'Test title'
      expect(page).to have_content 'Test body'
    end

    scenario 'with invalid attributes' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'with attached files' do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'with reward' do
      fill_in 'Name', with: 'Reward name'
      attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.png"

      click_on 'Ask'

      expect(page).to have_content 'Question successfully created.'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
