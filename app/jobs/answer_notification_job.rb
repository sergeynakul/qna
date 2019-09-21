class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::AnswerSubscription.new.send_subscription(answer)
  end
end
