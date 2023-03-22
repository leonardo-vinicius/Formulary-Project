class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show edit update destroy ]

  # GET /answers
  def index
    @answers = Answer.all
    render json: @answers
  end

  # GET /answers/1
  def show
    render json: @answer
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)
    @resp = Answer.joins(:visit).joins('INNER JOIN users ON users.id = visits.user_id').where(visits: { id: @answer.visit_id }).select('users.name')
    x = @resp.last.name
    @answer.answered_at = params[:answered_at] = x

    if @answer.save
      redirect_to @answer, notice: "Answer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      redirect_to @answer, notice: "Answer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy
    redirect_to answers_url, notice: "Answer was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.permit(:content, :answered_at, :formulary_id, :question_id, :visit_id)
    end
end
