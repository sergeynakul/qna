class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    resource = params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id]) # test
    @comment = resource.comments.new(comment_params)
    flash[:notice] = 'Comment successfully created.' if @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
