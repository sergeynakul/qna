class AnswersChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:id])
    stream_for question
  end
end
