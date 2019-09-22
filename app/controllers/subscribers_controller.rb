class SubscribersController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, Subscriber
    subscriber.save
  end

  def destroy
    authorize! :destroy, subscriber
    subscriber.destroy
  end

  private

  helper_method :question

  def subscriber
    @subscriber ||= Subscriber.find_or_initialize_by(user: current_user, question: question)
  end

  def question
    Question.find_by(id: params[:question_id] || params[:id])
  end
end
