require 'sphinx_helper'

feature 'User can search info', "
  In order to find needed info
  As a User
  I'd like to be able to search info
" do
  given!(:questions) { create_list(:question, 5) }
  given(:question) { questions.first }
  given!(:answers) { create_list(:answer, 5, question: question) }
  given(:answer) { answers.first }
  given!(:comments) { create_list(:comment, 5, :sequences, commentable: answer) }
  given(:comment) { comments.first }
  given!(:users) { create_list(:user, 5) }
  given(:user) { users.first }

  background { visit search_path }

  describe 'Questions search', sphinx: true, js: true do
    scenario 'User searches only in questions' do
      select 'Question', from: :search_indices
      fill_in :search_query, with: question.title

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_link 'Open question', href: question_path(question)
      (questions - [question]).each do |q|
        expect(page).to_not have_content q.title
        expect(page).to_not have_link 'Open question', href: question_path(q)
      end
    end

    scenario 'User tries search question in answers/comments/users' do
      %w[Answer Comment User].each do |index|
        select index, from: :search_indices
      end

      fill_in :search_query, with: question.title

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to_not have_content question.title
      expect(page).to_not have_link 'Open question', href: question_path(question)
    end
  end

  describe 'Answers search', sphinx: true, js: true do
    scenario 'User searches only in answers' do
      select 'Answer', from: :search_indices
      fill_in :search_query, with: answer.body

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to have_content answer.body
      expect(page).to have_link 'Open question', href: question_path(answer.question)
      (answers - [answer]).each do |a|
        expect(page).to_not have_content a.body
        expect(page).to have_link 'Open question', href: question_path(a.question)
      end
    end

    scenario 'User tries search answer in questions/comments/users' do
      %w[Question Comment User].each do |index|
        select index, from: :search_indices
      end

      fill_in :search_query, with: answer.body

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to_not have_content answer.body
      expect(page).to_not have_link 'Open question', href: question_path(answer.question)
    end
  end

  describe 'Comment search', sphinx: true, js: true do
    scenario 'User searches only in comments' do
      select 'Comment', from: :search_indices
      fill_in :search_query, with: comment.body

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to have_content comment.body
      expect(page).to have_link 'Open question', href: question_path(comment.commentable.question)
      (comments - [comment]).each do |c|
        expect(page).to_not have_content c.body
        expect(page).to have_link 'Open question', href: question_path(c.commentable.question)
      end
    end

    scenario 'User tries search comment in questions/answers/users' do
      %w[Question Answer User].each do |index|
        select index, from: :search_indices
      end

      fill_in :search_query, with: comment.body

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to_not have_content comment.body
      expect(page).to_not have_link 'Open question', href: question_path(comment.commentable.question)
    end
  end

  describe 'Users search', sphinx: true, js: true do
    scenario 'User searches only in users' do
      select 'User', from: :search_indices
      fill_in :search_query, with: user.email

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to have_content user.email
      (users - [user]).each do |u|
        expect(page).to_not have_content u.email
      end
    end

    scenario 'User tries search user in questions/answers/comments' do
      %w[Question Answer Comment].each do |index|
        select index, from: :search_indices
      end

      fill_in :search_query, with: user.email

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to_not have_content user.email
    end
  end

  describe 'Everywhere search', sphinx: true, js: true do
    given(:keyword) { 'some' }
    given!(:question) { create(:question, title: "#{keyword} question") }
    given!(:answer) { create(:answer, body: "#{keyword} asnwer") }
    given!(:comment) { create(:comment, body: "#{keyword} comment", commentable: question) }
    given!(:user) { create(:user, email: "#{keyword}@email.com") }

    scenario 'User search keyword' do
      fill_in :search_query, with: keyword

      ThinkingSphinx::Test.run do
        click_button 'Search'
      end

      expect(page).to have_content question.title
      expect(page).to have_link 'Open question', href: question_path(question)
      expect(page).to have_content answer.body
      expect(page).to have_link 'Open question', href: question_path(answer.question)
      expect(page).to have_content comment.body
      expect(page).to have_link 'Open question', href: question_path(comment.commentable)
      expect(page).to have_content user.email
    end
  end
end
