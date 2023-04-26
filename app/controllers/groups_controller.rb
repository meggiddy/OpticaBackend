class GroupsController < AdminsController

    def index
        render json: Group.all
    end

    def create
        group = Group.create(name: params[:name])
        render json: group, status: :created
    end

    def show
        group = Group.find(params[:id])
        render json: group
    end
end
