require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  describe 'User adds', js: true do
    given(:user) { create(:user) }
    given(:question) { create :question }
    given(:gist_url) { 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38' }
    given(:github_url) { 'https://github.com/' }
    given(:gismeteo_url) { 'https://www.gismeteo.ua/' }

    before do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Test answer body'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: github_url
    end

    scenario 'link when asks question' do
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My link', href: github_url
      end
    end

    scenario 'links when asks question' do
      click_on 'add link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My link 2'
        fill_in 'Url', with: gismeteo_url
      end

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My link', href: github_url
        expect(page).to have_link 'My link 2', href: gismeteo_url
      end
    end

    scenario 'invalid link' do
      fill_in 'Url', with: 'googlecom'
      click_on 'Create answer'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_link 'My link'
    end

    scenario 'link on gist' do
      fill_in 'Url', with: gist_url
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_content 'SQL запросы'
        expect(page).to have_content 'sergey@comp:~$ sqlite3 test_guru'
      end
    end
  end
end
