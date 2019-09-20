class Services::AnswerSubscription
  def send_subscription(answer)
    answer.question.subscribers.find_each do |subscriber|
      AnswersMailer.subscribers_notification(subscriber).deliver_later
    end
  end
end
