require 'rails_helper'

feature 'User can create question', "
  In order to receive answer
  as user
  I'd like to be able to create question
" do
  background do
    visit new_question_path
  end

  scenario 'with valid attributes' do
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'
    click_on 'Ask'

    expect(page).to have_content 'Question successfully created.'
    expect(page).to have_content 'Test title'
    expect(page).to have_content 'Test body'
  end

  scenario 'with valid attributes' do
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end
end
