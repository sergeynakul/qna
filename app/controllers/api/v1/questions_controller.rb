class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, except: %i[index create]

  def index
    authorize! :read, Question
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    authorize! :read, @question
    render json: @question
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    render json: @question, status: :ok
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
