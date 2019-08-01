class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_questions, only: %i[index update]
  before_action :set_question, only: %i[show update destroy]

  def index; end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question successfully deleted.'
    else
      redirect_to @question, alert: "You don't author this question"
    end
  end

  private

  def set_questions
    @questions = Question.all
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
