class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @resource = params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id]) # test
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    flash[:notice] = 'Comment successfully created.' if @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    question_id = @resource.class == Question ? @resource.id : @resource.question_id

    ActionCable.server.broadcast("comments-question-#{question_id}", comment: @comment)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
