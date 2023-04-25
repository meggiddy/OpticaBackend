class SessionsController < ApplicationController

    skip_before_action :authorized, only: [:create, :google_user]
    
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

  # check and create google user
  def google_user
    user = User.find_by(email: params[:email])
    if user
      # session[:user_id] = user.id
      puts "User found: #{user.inspect}" 
      # cookies.signed[:user_id] = user.id # Store user ID in a signed cookie
      token = encode_token({user_id: user.id})
      render json: { loggedin: true, user: user, jwt: token, status: 'loggedin' }
    else
      # Create a new user with the provided email and name
      new_user = User.create(email: params[:email], name: params[:name], password: 'swr23r3r3r334gdvrv', password_confirmation: 'swr23r3r3r334gdvrv')
      # session[:user_id] = new_user.id
      puts "New user created: #{new_user.inspect}" 
      # cookies.signed[:user_id] = new_user.id # Store user ID in a signed cookie
      token = encode_token({user_id: new_user.id})
      render json: { loggedin: true, user: new_user, jwt:token, status:'registered' }
    end
  end

 
  # clear JWT token from client's storage
   def destroy
    cookies.delete(:jwt_token)
    render json: { message: 'Logged out successfully' }
  end

  private
  def session_params
    params.permit(:email, :name)
  end
    
end