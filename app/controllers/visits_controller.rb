class VisitsController < ApplicationController
    
    def index
        @visits = Visit.all
    
        render json: @visits
      end

      def create

        @visit = Visit.new(visit_params)
    
        if @visit.save
          render json: @visit, status: :created, location: @visit
        else
          render json: @visit.errors, status: :unprocessable_entity
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_visit
        @visit = Visit.find(params[:id])
      end
      
      # Only allow a list of trusted parameters through.
      def visit_params
        params.require(:visit).permit(:status, checkin_at:, checkout_at:)
      end

end
