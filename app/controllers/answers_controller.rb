class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer successfully deleted.'
    else
      redirect_to @answer.question, alert: "You don't author the answer"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
