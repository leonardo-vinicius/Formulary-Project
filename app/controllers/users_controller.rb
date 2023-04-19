# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request, except: :create

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    if User.exists?(params[:id])
      set_user
      render json: @user
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :cpf)
  end

end