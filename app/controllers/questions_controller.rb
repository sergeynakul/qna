class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_questions, only: %i[index update]
  before_action :set_question, only: %i[show update destroy]
  after_action :publish_question, only: :create

  def index; end

  def show
    @answer = Answer.new
    @comment = Comment.new
    @answer.links.new
    gon.user_id = current_user.id if current_user
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
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
    @question.destroy if current_user.author?(@question)
  end

  private

  def set_questions
    @questions = Question.all
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/one_question', locals: { question: @question }))
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[id name url _destroy], reward_attributes: %i[name image])
  end
end
