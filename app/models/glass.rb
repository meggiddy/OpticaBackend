class Glass < ApplicationRecord
    
    validates :model_no, uniqueness: { case_sensitive: false }, presence: true
    validates :price,  presence: true
    validate :non_zero

    has_many :sales

    def non_zero
        if(self.price <= 0)
            self.errors.add(:price, " can't be zero")
        end
    end
end
