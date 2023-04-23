class AdminsController < ActionController::API
    wrap_parameters format: []
    include ActionController::Cookies

    before_action :authenticate_staff

    private

    def authenticate_staff
        # Decode and verify JWT token from the 'jwt' cookie
        token = cookies.signed[:jwt]
        if token.present?
            begin
                payload = JWT.decode(token, 'my-secret-key', true, { algorithm: 'HS256' }).first
                @admin = User.find_by(email: payload['email'], is_admin: true)
            rescue JWT::DecodeError => e
                # Invalid JWT token
                head :unauthorized
            end
        end

        # If no valid JWT token found, redirect to login page
        unless @admin
            head :unauthorized
        end
    end
end