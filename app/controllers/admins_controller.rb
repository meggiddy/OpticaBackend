require 'base64'

class AdminsController < ActionController::API
    wrap_parameters format: []
    include ActionController::Cookies

    before_action :authenticate_staff

    def new_product

        glass = Glass.create({
            model_no: params[:model_no],
            price: params[:price].to_f,
            brand_name: params[:brand],
            has_colors: true,
            colors: params[:colors],
            frame_size: params[:frame_size],
            lens_width: params[:lens_width]
        })

        directory_path = Rails.root.join('public', 'glass', params[:brand], params[:model_no])
        Dir.mkdir(directory_path) unless File.directory?(directory_path)

        colors = params[:colors].split "|"
        image_sets = params[:image_sets]
        colors.each do |color|
            new_path = directory_path+color
            Dir.mkdir(new_path) unless File.directory?(new_path)

            save_image(new_path, image_sets[color.to_s])
        end

        render json: { message: "Product created succesfully" }, status: :created
    end

    def save_image(path, images)
        extensions = ["___45.jpg", "___FRONT.jpg", "___SIDE.jpg"]
        extensions.each.with_index do |ext, index|
            base64_string = images[index].split(",")[-1]

            # decode the base64 string
            image_data = Base64.decode64(base64_string)

            # write the decoded data to a file
            File.open(path+ext, 'wb') do |f|
                f.write image_data
            end
        end
    end

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