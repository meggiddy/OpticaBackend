require 'base64'

class AdminsController < ActionController::API
    wrap_parameters format: []
    include ActionController::Cookies
    rescue_from ActiveRecord::RecordNotFound, with: :response_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    before_action :authenticate_staff

    def users
        render json: User.all
    end

    def get_user
        user = User.find(params[:id])
        render json: user
    end

    def update_user
    end

    def update_product
        glass = Glass.find(params[:id])
        
        glass.colors = glass.colors.split("|").concat(params[:new_images].split("|"))
        glass_params = {
            price: params[:price],
            discount: params[:discount],
            colors: params[:new_images]
        }

        update_params = {**glass_params}
        update_params[:colors] = params[:colors]
        
        if glass.update!(update_params)
            directory_path = Rails.root.join('public', 'glass', glass.brand_name, glass.model_no)
            Dir.mkdir(directory_path) unless File.directory?(directory_path)

            if glass_params[:colors].length > 0
                colors = glass_params[:colors].split "|"
                image_sets = params[:image_sets]
                colors.each do |color|
                    new_path = directory_path+color
                    Dir.mkdir(new_path) unless File.directory?(new_path)

                    save_image(new_path, image_sets[color.slice(1).to_s])
                end
            end
        end

        render json: { message: "Product updated succesfully" }, status: :created
    end

    def new_product
        glass = Glass.new({
            model_no: params[:model_no],
            price: params[:price].to_f,
            brand_name: params[:brand],
            has_colors: true,
            colors: params[:colors],
            frame_size: params[:frame_size],
            lens_width: params[:lens_width]
        })

        if glass.save!
            directory_path = Rails.root.join('public', 'glass', params[:brand], params[:model_no])
            Dir.mkdir(directory_path) unless File.directory?(directory_path)

            colors = params[:colors].split "|"
            image_sets = params[:image_sets]
            colors.each do |color|
                new_path = directory_path+color
                Dir.mkdir(new_path) unless File.directory?(new_path)

                save_image(new_path, image_sets[color.to_s])
            end
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

    def response_not_found
        render json: {error: "#{controller_name.classify} not found"}, status: :not_found
    end

    def unprocessable_entity_response(invalid)
        render json: invalid.record.errors.full_messages, status: :unprocessable_entity
    end
end