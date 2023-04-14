class GlassesController < ApplicationController
    skip_before_action :authorized, only: [:index, :show, :get_by_brand, :get_by_color]

    def index
        render json: Glass.all()
    end

    def show
        render json: Glass.find(params[:id])
    end

    def get_by_brand
        glasses = Glass.where(brand_name: params[:brand])
        render json: glasses
    end

    def get_by_color
        glasses = Glass.where("colors LIKE ?", "%#{params[:color]}%")
        render json: glasses
    end
end
