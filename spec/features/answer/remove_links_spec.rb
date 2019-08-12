require 'rails_helper'

feature 'User can remove links for answer', "
  In order to remove additional information
  As an answer's author
  I'd like to be able to remove links
" do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:answer) { create(:answer, user: user, question: question) }
    given!(:link) { create(:link, linkable: answer) }

    scenario 'removes link on his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        click_on 'remove link'
        click_on 'Save'
      end

      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
