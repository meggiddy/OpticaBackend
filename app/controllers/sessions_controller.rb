class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:create]
    
  def create
     user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        token = encode_token({user_id: user.id})
        render json: {loggedin: true, user: user, jwt: token }, status: :accepted
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
  end

  def me
    render json: @user
  end

  # clear JWT token from client's storage
   def destroy
    cookies.delete(:jwt_token)
    render json: { message: 'Logged out successfully' }
  end

  private

  def session_params
    params.permit(:email, :password)
  end
    
end