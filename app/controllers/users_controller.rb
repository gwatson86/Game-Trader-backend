class UsersController < ApplicationController
  skip_before_action :authorized, only: [:index, :create]
  skip_before_action :verify_authenticity_token, only: [:create]
  wrap_parameters false

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end
  
  def create
    @new_user = User.create(user_params)
    if @new_user.valid?
      @token = encode_token(user_id: @new_user.id)
      render json: { new_user: @new_user, jwt: @token }, status: :created
    else
      render json: {error: 'Failed'}, status: :not_acceptable
    end
  end

  def update
    @user.update(user_params)
    
    if @user.save
      render json: @user, status: :accepted
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessible_entity
    end
  end

  # def login
  #   @user = User.find_by(username: params[:username])
    
  #   if @user && @user.authenticate(params[:password])
  #     render :json => {
  #       :token => JWT.encode( {user_id: @user.id }, nil, 'none')
  #     }
  #   else
  #     render :json => {
  #       :message => "Invalid credentials"
  #     }, status: 400
  #   end
  # end
  
  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
    #params.fetch(:user, {}).permit(:username, :email, :password, :password_confirmation)
  end
end