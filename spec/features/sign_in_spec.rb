require 'rails_helper'

feature 'User can sign in', "
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can sign in with Github' do
    mock_auth_hash
    click_on 'Sign in with GitHub'
    open_email('mockuser@mail.com')
    expect(current_email).to have_content 'Welcome mockuser@mail.com!'

    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User can sign in with Instagram' do
    mock_auth_hash_without_mail
    click_on 'Sign in with Instagram'
    expect(page).to have_content 'Add your email'

    fill_in 'auth_hash[info][email]', with: 'instagram@mail.com'
    click_on 'Add'
    open_email('instagram@mail.com')
    expect(current_email).to have_content 'Welcome instagram@mail.com'

    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_on 'Sign in with Instagram'
    expect(page).to have_content 'Successfully authenticated from Instagram account.'
  end
end
