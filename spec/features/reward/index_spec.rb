require 'rails_helper'

feature 'User can view his rewards', "
  In order to know his rewadrs
  As an authenticated user
  I'd like to be able to view my rewards
" do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
  given!(:reward) { create(:reward, question: question, name: 'reward name', image: image, answer: answer) }
  given!(:answer) { create(:answer, user: other_user, question: question, best: true) }

  describe 'Authenticated user' do
    scenario 'can view his rewards if they are' do
      sign_in(other_user)
      click_on 'Your rewards'

      expect(page).to have_content question.title
      expect(page).to have_content reward.name
      expect(page).to have_css "img[src*='#{reward.image.filename}']"
    end

    scenario "can't view his rewards if they aren't" do
      sign_in(user)
      click_on 'Your rewards'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content reward.name
      expect(page).to_not have_css "img[src*='#{reward.image.filename}']"
    end
  end
end
