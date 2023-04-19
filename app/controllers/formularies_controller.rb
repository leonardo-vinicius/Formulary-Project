# frozen_string_literal: true

class FormulariesController < ApplicationController
  before_action :authenticate_request

  # GET /formularies
  def index
    @formularies = Formulary.all
    render json: @formularies
  end

  # GET /formularies/1
  def show
    if Formulary.exists?(params[:id])
      set_formulary
      render json: @formulary
    else
      render json: { error: 'Formulary not found' }, status: :not_found
    end
  end

  # POST /formularies
  def create
    @formulary = Formulary.new(formulary_params)

    if @formulary.save
      render json: @formulary
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /formularies/1
  def update
    if Formulary.exists?(params[:id])
      set_formulary
      if @formulary.update(formulary_params)
        render json: @formulary
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render json: { error: 'Formulary not found' }, status: :not_found
    end
  end

  # DELETE /formularies/1
  def destroy
    if Formulary.exists?(params[:id])
      set_formulary
      @formulary.destroy
      render json: { message: 'Formulary was successfully destroyed.' }
    else
      render json: { error: 'Formulary not found' }, status: :not_found
    end
  end

  private
  
  def set_formulary
    @formulary = Formulary.find(params[:id])
  end

  def formulary_params
    params.permit(:name, :visit_id)
  end
end
