class GlassSerializer < ActiveModel::Serializer
  attributes :id, :brand_name, :model_no, :has_colors, :colors 
end
