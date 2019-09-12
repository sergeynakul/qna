class Api::V1::AnswersController < Api::V1::BaseController
  def show
    @answer = Answer.with_attached_files.find(params[:id])
    authorize! :read, @answer
    render json: @answer
  end

  def create
    authorize! :create, Answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save ? head(:ok) : head(422)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
