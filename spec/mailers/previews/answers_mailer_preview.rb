# Preview all emails at http://localhost:3000/rails/mailers/answers_mailer
class AnswersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/answers_mailer/subscribers_notification
  def subscribers_notification
    user = User.new(email: 'test@email.com')
    answer = Answer.new(body: 'Ansewer body')
    question = Question.new(title: 'Question title', body: 'Question body', answers: [answer])
    subscriber = Subscriber.new(question: question, user: user)
    AnswersMailer.subscribers_notification(subscriber)
  end
end
