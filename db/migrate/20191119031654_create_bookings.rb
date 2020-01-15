class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subpitch, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :message
      t.integer :status
      t.decimal :total_price

      t.timestamps
    end
  end
end
