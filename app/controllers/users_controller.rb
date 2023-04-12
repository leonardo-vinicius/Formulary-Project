class UsersController < ApplicationController
    before_action :authenticate_request, except: :create
    #before_action :authorize_request, except: :create
    #before_action :set_user, only: %i[ show update destroy ]
  
    # GET /users
    def index
      @users = User.all
  
      render json: @users
    end
  
    # GET /users/1
    def show
      if User.exists?(params[:id])
        #@user = User.find(params[:id])
        set_user
        render json: @user
      else
        #render json: @user.errors, status: 404
        render json: { error: 'User not found' }, status: :not_found
        # handle the case where the user doesn't exist
        # e.g. redirect to an error page or show a flash message
      end
      
    end

    # POST /users
    def create
      @user = User.new(user_params)
  
      if @user.save
        #rende/home/leo/form/app2/app/modelsr json: @user, status: :created, location: @user
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if User.exists?(params[:id])

        set_user
        if @user.update(user_params)
          #render json: @UsersController
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'User not found' }, status: :not_found
      end

    end
  
    # DELETE /users/1

    def destroy
      if User.exists?(params[:id])
        set_user
        @user.destroy
        render json: { message: 'User deleted successfully' }

      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
      
      # Only allow a list of trusted parameters through.
      def user_params
        params.permit(:name, :email, :password, :password_confirmation, :cpf)
      end
      
end
  