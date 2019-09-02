class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[update destroy best]
  before_action :new_comment, only: %i[update create best]
  after_action :publish_answer, only: :create

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Answer successfully created.' if @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def best
    @question = @answer.question
    @answer.best! if current_user.author?(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def new_comment
    @comment = Comment.new
  end

  def publish_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(
      @answer.question,
      answer: @answer,
      links: @answer.links,
      files: @answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
