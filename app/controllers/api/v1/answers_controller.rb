class Api::V1::AnswersController < Api::V1::BaseController
  def show
    @answer = Answer.with_attached_files.find(params[:id])
    authorize! :read, @answer
    render json: @answer
  end
end
