require 'rails_helper'

RSpec.describe AnswersMailer, type: :mailer do
  describe 'subscribers_notification' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: create(:user)) }
    let(:subscriber) { create(:subscriber, question: question, user: other_user) }
    let(:mail) { AnswersMailer.subscribers_notification(subscriber) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Subscribers notification')
      expect(mail.to).to eq([subscriber.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_content(question.title)
      expect(mail.body.encoded).to have_content('New answer for a question')
    end
  end
end
