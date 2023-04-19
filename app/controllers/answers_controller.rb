# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_request

  # GET /answers
  def index
    @answers = Answer.all

    @answers.each do |resp|
      visit = Visit.find(resp.visit_id)
      usuario = User.find(visit.user_id).name
      resp.answered_at = usuario
    end

    render json: @answers
  end

  # GET /answers/1
  def show

    if Answer.exists?(params[:id])
      set_answer
      visit = Visit.find(@answer.visit_id)
      usuario = User.find(visit.user_id).name
      @answer.answered_at = usuario
      render json: @answer
    else
      render json: { error: 'User not found' }, status: :not_found
    end
    
  end

  # POST /answers
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      render json: @answer
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if Answer.exists?(params[:id])
      set_answer
      if @answer.update(answer_params)
        render json: @answer
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # DELETE /answers/1
  def destroy
    if Answer.exists?(params[:id])
      set_answer
      @answer.destroy
      render json: { message: 'Answer was successfully destroyed.' } 
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:content, :formulary_id, :question_id, :visit_id)
  end
end
