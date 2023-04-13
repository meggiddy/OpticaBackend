class CreateGlasses < ActiveRecord::Migration[6.1]
  def change
    create_table :glasses do |t|
      t.string :brand_name
      t.string :file_url

      t.timestamps
    end
  end
end
