class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @comment = @question.comments.new(comment_params)
    flash[:notice] = 'Comment successfully created.' if @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
