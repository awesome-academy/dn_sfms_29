class CreateRecharges < ActiveRecord::Migration[6.0]
  def change
    create_table :recharges do |t|
      t.bigint :sender_id
      t.bigint :receiver_id
      t.string :content
      t.decimal :money

      t.timestamps
    end
    add_index :recharges, :sender_id
    add_index :recharges, :receiver_id
  end
end
