require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:service) { double('Services::AnswerSubscription') }
  let(:answer) { create(:answer) }

  before do
    allow(Services::AnswerSubscription).to receive(:new).and_return(service)
  end

  it 'calls Services::AnswerSubscription#send_subscription' do
    expect(service).to receive(:send_subscription).with(answer)

    AnswerNotificationJob.perform_now(answer)
  end
end
