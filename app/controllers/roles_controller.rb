class RolesController < AdminsController

    def index
        render json: Role.all
    end

    def show
        render json: Role.find(params[:id])
    end

    def create
        role = Role.create(role_params)
        render json: role, status: :created
    end

    def update
        role = Role.find(params[:id])
        role.update
        render json: role, status: :created
    end

    def destroy
        role = role.find(params[:id])
        role.destroy
        head :no_content
    end

    def role_params
        params.permit(:name, :description)
    end
end
