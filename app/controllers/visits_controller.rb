class VisitsController < ApplicationController
  before_action :set_visit, only: %i[ show edit update destroy ]

  # GET /visits
  def index
    @visits = Visit.all
    render json: @visits
  end

  # GET /visits/1
  def show
    render json: @visit
  end

  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
  end

  # função para validações
  def validation_datas

    if @visit.data < Time.now
      return false
    end

    if @visit.checkin_at < Time.now and @visit.checkin_at < @visit.checkout
      return false
    end

    if @visit.checkout_at <= @visit.checkin_at
      return false
    end

    return true
  end

  # POST /visits
  def create
    @visit = Visit.new(visit_params)
  
      validacao = true
      validacao = validation_datas()

    if @visit.save and validacao
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
      params.permit(:data, :status, :checkin_at, :checkout_at, :user_id)
    end
end
