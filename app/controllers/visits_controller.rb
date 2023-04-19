# frozen_string_literal: true

class VisitsController < ApplicationController
  before_action :authenticate_request

  # GET /visits
  def index
    @visits = Visit.all
    render json: @visits
  end

  # GET /visits/1
  def show
    if Visit.exists?(params[:id])
      set_visit
      render json: @visit
    
    else
      render json: { error: 'Visit not found' }, status: :not_found
    end
  end

  # função para validações
  def validation_datas
    if (@visit.data < Time.now) || @visit.checkin_at >= Time.now || @visit.checkin_at >= @visit.checkout_at
      return false
    end

    return true
  end

  # POST /visits
  def create
    @visit = Visit.new(visit_params)
    validacao = validation_datas

    if @visit.save && validacao
      render json: @visit
    else
      render json: @visit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /visits/1
  def update
    if Visit.exists?(params[:id])
      set_visit
      if @visit.update(visit_params)
        render json: @visit
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render json: { error: 'Visit not found' }, status: :not_found
    end
  end

  # DELETE /visits/1
  def destroy
    if Visit.exists?(params[:id])
      set_visit
      @visit.destroy
      render json: { message: 'Visit was suessfully destroyed' }
    else
      render json: { error: 'Visit not found' }, status: :not_found
    end
  end

  private
  
  def set_visit
    @visit = Visit.find(params[:id])
  end

  def visit_params
    params.permit(:data, :status, :checkin_at, :checkout_at, :user_id)
  end
end
