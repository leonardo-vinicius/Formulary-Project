class VisitsController < ApplicationController
  #before_action :set_visit, only: %i[ show edit update destroy ]

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
      p "data"
      return false
    end

    if @visit.checkin_at >= Time.now
      p "checkin < agora"
      return false
    end

    if  @visit.checkin_at >= @visit.checkout_at
      p "checkin > checkout"
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
      #redirect_to @visit, notice: "Visit was successfully created."
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
        #redirect_to @visit, notice: "Visit was successfully updated."
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
      #redirect_to visits_url, notice: "Visit was successfully destroyed."
      render json: {message: 'Visit was suessfully destroyed'}
    else
      render json: { error: 'Visit not found' }, status: :not_found
    end

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
