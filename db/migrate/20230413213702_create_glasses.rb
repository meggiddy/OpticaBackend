class CreateGlasses < ActiveRecord::Migration[6.1]
  def change
    create_table :glasses do |t|
      t.string :brand_name
      t.string :model_no
      t.boolean :has_colors
      t.string :colors
     

      t.timestamps
    end
  end
end
