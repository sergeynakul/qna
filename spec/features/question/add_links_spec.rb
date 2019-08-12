require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  describe 'User adds', js: true do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38' }
    given(:github_url) { 'https://github.com/' }
    given(:gismeteo_url) { 'https://www.gismeteo.ua/' }

    before do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: github_url
    end

    scenario 'link when asks question' do
      click_on 'Ask'

      expect(page).to have_link 'My link', href: github_url
    end

    scenario 'links when asks question' do
      click_on 'add link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My link 2'
        fill_in 'Url', with: gismeteo_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My link', href: github_url
      expect(page).to have_link 'My link 2', href: gismeteo_url
    end

    scenario 'invalid link' do
      fill_in 'Url', with: 'googlecom'

      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_link 'My link'
    end

    scenario 'link on gist' do
      fill_in 'Url', with: gist_url
      click_on 'Ask'

      expect(page).to have_content 'SQL запросы'
      expect(page).to have_content 'sergey@comp:~$ sqlite3 test_guru'
    end
  end
end
