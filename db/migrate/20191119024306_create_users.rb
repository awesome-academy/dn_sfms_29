class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :avatar
      t.boolean :activated, default: false
      t.string :activation_digest
      t.datetime :activated_at
      t.string :email
      t.string :full_name
      t.boolean :gender
      t.string :phone
      t.string :password_digest
      t.string :reset_digest
      t.integer :role, default: 2
      t.datetime :reset_sent_at
      t.string :remember_digest
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, [:provider, :email], unique: true
    add_index :users, :uid, unique: true
  end
end
