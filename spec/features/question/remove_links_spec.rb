require 'rails_helper'

feature 'User can remove links for question', "
  In order to remove additional information
  As an question's author
  I'd like to be able to remove links
" do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }

    scenario 'removes link on his question' do
      sign_in(user)
      visit questions_path

      click_on 'Edit'
      click_on 'remove link'
      click_on 'Ask'

      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
