require 'rails_helper'

feature 'User can sign up', "
  In order to sign in
  As an unregistered user
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  scenario 'with valid attributes' do
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'with invalid attributes' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
