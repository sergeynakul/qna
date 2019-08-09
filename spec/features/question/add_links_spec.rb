require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  describe 'User adds', js: true do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38' }
    given(:other_gist_url) { 'https://gist.github.com/sergeynakul/c1fa04dd4231f57f5a5047b75886f195' }

    before do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'link when asks question' do
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'links when asks question' do
      click_on 'add link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My gist 2'
        fill_in 'Url', with: other_gist_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist 2', href: other_gist_url
    end

    scenario 'invalid link' do
      fill_in 'Url', with: 'googlecom'

      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_link 'My gist'
    end
  end
end
