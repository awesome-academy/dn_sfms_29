class CreatePitches < ActiveRecord::Migration[6.0]
  def change
    create_table :pitches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :country
      t.string :city
      t.string :district
      t.string :address
      t.string :phone
      t.text :picture
      t.datetime :start_time
      t.datetime :end_time
      t.integer :limit

      t.timestamps
    end
  end
end
