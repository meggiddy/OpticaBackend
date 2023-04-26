class GlassSerializer < ActiveModel::Serializer
  attributes :id, :brand_name, :model_no, :has_colors, :colors, :price, :frame_size, :lens_width, :discount
end
