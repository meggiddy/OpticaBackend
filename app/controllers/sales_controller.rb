class SalesController < AdminsController

    skip_before_action :authenticate_staff, only: [:by_brand]

    def by_brand
        render json: Sale.all.map {|sale| { brand: sale.glass.brand_name, selling_price: sale.glass.price } }
    end
end
