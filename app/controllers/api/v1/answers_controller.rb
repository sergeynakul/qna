class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, except: :create

  def show
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

  def update
    authorize! :update, @answer
    @answer.update(answer_params) ? head(:ok) : head(422)
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
