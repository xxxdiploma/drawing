class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :user_id, :null => false
      t.text :code

      t.timestamps
    end
    add_index :pictures, :user_id
    add_index :pictures, :created_at
  end
end
