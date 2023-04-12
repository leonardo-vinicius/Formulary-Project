class QuestionsController < ApplicationController
  #before_action :set_question, only: %i[ show edit update destroy ]

  # GET /questions
  def index

    @questions = Question.all
    render json: @questions
  end

  # GET /questions/1
  def show
    if Question.exists?(params[:id])
      set_question
      render json: @question
    else
      render json: { error: 'Question not found' }, status: :not_found
    end
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    validacao = true
    Question.all.each do |perguntas|
        if perguntas.name == @question.name and perguntas.formulary_id == @question.formulary_id
          validacao = false
        end
    end 

    if @question.save and validacao
      #redirect_to @question, notice: "Question was successfully created."
      render json: @question
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if Question.exists?(params[:id])
      set_question
      if @question.update(question_params)
        #redirect_to @question, notice: "Question was successfully updated."
        render json: @question
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render json: { error: 'Question not found' }, status: :not_found
    end
  end

  # DELETE /questions/1
  def destroy

    if Question.exists?(params[:id])
      set_question
      @question.destroy
      #redirect_to questions_url, notice: "Question was successfully destroyed."
      render json: {message: 'Question was successfully destroyed.'}
    else
      render json: { error: 'Question not found' }, status: :not_found
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.permit(:name, :tipo_pergunta, :formulary_id)
    end
end
