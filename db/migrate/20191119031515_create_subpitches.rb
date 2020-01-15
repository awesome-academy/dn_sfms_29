class CreateSubpitches < ActiveRecord::Migration[6.0]
  def change
    create_table :subpitches do |t|
      t.string :name
      t.string :description
      t.integer :status, default: 0
      t.references :pitch, null: false, foreign_key: true
      t.decimal :price_per_hour, precision: 10, scale: 0
      t.string :currency
      t.text :picture
      t.string :size
      t.references :subpitch_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
