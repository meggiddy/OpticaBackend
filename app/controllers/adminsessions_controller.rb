class AdminsessionsController < AdminsController

  skip_before_action :authenticate_staff, only: [:create]

    def create
      admin = User.find_by(email: session_params[:email])
      if admin && admin.authenticate(session_params[:password])
        if admin.is_admin
          # Validating user credentials and generate JWT token
          token = JWT.encode({ email: admin.email }, 'my-secret-key', 'HS256')
          # Set an HTTP-only cookie containing the JWT token
          # Rails.env.production?
          cookies.signed[:jwt] = { value: token, httponly: true, secure: false }

          render json: admin, status: :ok
        else
          render json: { error: 'Unauthorized access. Please contact your administrator.' }, status: :unauthorized
        end
      else
        render json: { error: 'invalid Email or Password' }, status: :unauthorized
      end
    end

    def logout
      cookies.delete(:jwt, httponly: true) # Clearing HttpOnly cookie
      head :no_content
    end

    def current_admin
      render json: @admin
    end

    private

    def session_params
      params.permit(:email, :password)
    end
  end