class AnswersMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answers_mailer.subscribers_notification.subject
  #
  def subscribers_notification(subscriber)
    @subscriber = subscriber

    mail to: subscriber.user.email
  end
end
