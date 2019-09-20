require 'rails_helper'

RSpec.describe Services::AnswerSubscription do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:answer) { create(:answer, question: question, user: users[1]) }
  let!(:subscriber) { create(:subscriber, question: question, user: users[2]) }

  it 'sends email to all subscribed users' do
    expect(question.subscribers.size).to eq 2

    question.subscribers.each do |subscriber|
      expect(AnswersMailer).to receive(:subscribers_notification).with(subscriber).and_call_original
    end

    subject.send_subscription(answer)
  end

  it 'do not send email to not subscribed users' do
    expect { subject.send_subscription(answer) }.to_not change(ActionMailer::Base.deliveries, :count)
  end
end
