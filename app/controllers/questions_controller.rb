class QuestionsController < ApplicationController
  before_action :authenticate_request

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
      render json: {message: 'Question was successfully destroyed.'}
    else
      render json: { error: 'Question not found' }, status: :not_found
    end
    
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.permit(:name, :tipo_pergunta, :formulary_id)
    end
end
