class FormulariesController < ApplicationController
  before_action :set_formulary, only: %i[ show edit update destroy ]

  # GET /formularies
  def index
    @formularies = Formulary.all
  end

  # GET /formularies/1
  def show
  end

  # GET /formularies/new
  def new
    @formulary = Formulary.new
  end

  # GET /formularies/1/edit
  def edit
  end

  # POST /formularies
  def create
    @formulary = Formulary.new(formulary_params)

    if @formulary.save
      redirect_to @formulary, notice: "Formulary was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /formularies/1
  def update
    if @formulary.update(formulary_params)
      redirect_to @formulary, notice: "Formulary was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /formularies/1
  def destroy
    @formulary.destroy
    redirect_to formularies_url, notice: "Formulary was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulary
      @formulary = Formulary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def formulary_params
      params.require(:formulary).permit(:name, :visit_id)
    end
end
