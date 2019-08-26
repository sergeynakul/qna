class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments-question-#{params[:questionId]}"
  end
end
