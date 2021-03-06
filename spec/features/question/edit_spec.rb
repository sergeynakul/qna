require 'rails_helper'

feature 'User can edit question', "
  In order to correct mistakes
  As an author a question
  I'd like to be able edit my question
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:github_url) { 'https://github.com/' }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path

      click_on 'Edit'
    end

    scenario 'edits his question' do
      fill_in 'Title', with: 'edited title'
      fill_in 'Body', with: 'edited body'
      click_on 'Ask'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'edits his question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Ask'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_selector 'textarea'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his question with attached files' do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete his file' do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      within "#question-#{question.id}" do
        first('.file').click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'can add link to his question' do
      click_on 'add link'

      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: github_url

      click_on 'Ask'

      expect(page).to have_link 'My link', href: github_url
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in(other_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
