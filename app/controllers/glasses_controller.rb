require 'net/http'
require 'json'

class GlassesController < ApplicationController
    skip_before_action :authorized, only: [:index, :show, :get_by_brand, :get_by_color, :virtual_search, :get_by_price, :sun_glasses]

    def index
        render json: Glass.all()
    end

    def show
        render json: Glass.find(params[:id])
    end

    def sun_glasses
        render json: Glass.where(brand_name: "sunglass")
    end

    def get_by_price
        minimum = params[:min]
        maximum = params[:max]

        glasses = Glass.where("price > ? AND price < ?", minimum, maximum)
        render json: glasses
    end

    def get_by_brand
        glasses = []
        if params[:brand] == "All"
            glasses = Glass.all
        else
            glasses = Glass.where(brand_name: params[:brand])
        end
        render json: glasses
    end

    def get_by_color
        glasses = []
        if params[:color] == "Any"
            glasses = Glass.all
        else
            glasses = Glass.where("colors LIKE ?", "%#{params[:color]}%")
        end
        render json: glasses
    end

    def virtual_search
        uri = URI('http://localhost:8000/imagefilter/upload')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data({
            'image' => params[:image]
        })
        response = http.request(request)

        sims = JSON.parse(response.body)

        sims = sims.map do |hash|
            key = hash.keys[0]
            value = hash[key]
            key = key.to_s
            key = key.split(" ").length == 2 ? key.split(" ")[0] : key[0...key.index("_")]
            {key => value.to_f}
        end
        
        above_threshhold_sims = sims.filter {|file| file[file.keys[0]] > params[:score].to_f }
        
        keys = []
        
        glasses = []
        above_threshhold_sims = above_threshhold_sims.each do |glass|
            if !keys.include?(glass.keys[0])
                keys.push(glass.keys[0])
                gls = Glass.find_by(model_no: glass.keys[0])
                if gls
                    hash = {
                        id: gls.id,
                        brand_name: gls.brand_name,
                        model_no: gls.model_no,
                        has_colors: gls.has_colors,
                        colors: gls.colors,
                        similarity_score: glass[glass.keys[0]]
                    }
                    glasses.push(hash)
                end
            end
        end
        
        render json: glasses
    end
end
# 