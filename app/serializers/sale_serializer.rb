class SaleSerializer < ActiveModel::Serializer
  attributes :id, :glass_id, :user_id, :date
end
