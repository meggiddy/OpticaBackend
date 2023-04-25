class CreateGlasses < ActiveRecord::Migration[6.1]
  def change
    create_table :glasses do |t|
      t.string :brand_name
      t.string :model_no
      t.boolean :has_colors
      t.string :colors
      t.decimal :price
      t.string :frame_size
      t.string :lens_width
      t.decimal :discount

      t.timestamps
    end
  end
end
