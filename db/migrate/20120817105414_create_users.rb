class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :surname
      t.string  :initials
      t.string  :email
      t.string  :encrypted_password
      t.string  :salt
      t.boolean :admin, :default => false
      t.string  :timezone, :default => "Moscow"

      t.timestamps
    end
    add_index :users, :email, :unique => true
  end
end
