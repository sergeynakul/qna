class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    authorize! :read, Question
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    authorize! :read, @question
    render json: @question
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)
    @question.save ? head(201) : head(422)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
