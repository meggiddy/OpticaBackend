class CreateSales < ActiveRecord::Migration[6.1]
  def change
    create_table :sales do |t|
      t.string :glass_id
      t.string :color
      t.string :user_id
      t.string :mode_of_payment
      t.date :date

      t.timestamps
    end
  end
end
