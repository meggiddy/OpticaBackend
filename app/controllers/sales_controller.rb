class SalesController < AdminsController

    skip_before_action :authenticate_staff, only: [:by_brand, :by_color, :by_mode_of_payment, :index]

    def index
        sales = Sale.all
        render json: sales.map { |sale| {amount: sale.glass.price, brand: sale.glass.brand_name, date: Date.parse(sale.date.to_s).strftime("%B")} }
    end

    def by_brand
        render json: Sale.all.map {|sale| { brand: sale.glass.brand_name, selling_price: sale.glass.price } }
    end

    def by_color
        render json: Sale.all.map {|sale| { color: sale.color, selling_price: sale.glass.price } }
    end

    def by_mode_of_payment
        render json: Sale.all.map {|sale| { payment: sale.mode_of_payment, selling_price: sale.glass.price } }
    end
end
