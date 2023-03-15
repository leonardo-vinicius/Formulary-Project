class VisitsController < ApplicationController
  before_action :set_visit, only: %i[ show edit update destroy ]

  # GET /visits
  def index
    @visits = Visit.all
  end

  # GET /visits/1
  def show
  end

  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
  end

  # POST /visits
  def create
    @visit = Visit.new(visit_params)

    if @visit.save
      redirect_to @visit, notice: "Visit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /visits/1
  def update
    if @visit.update(visit_params)
      redirect_to @visit, notice: "Visit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /visits/1
  def destroy
    @visit.destroy
    redirect_to visits_url, notice: "Visit was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def visit_params
      params.require(:visit).permit(:data, :status, :checkin_at, :checkout_at, :user_id)
    end
end
