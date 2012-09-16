class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.integer :user_id, :null => false
      t.string :file_name, :null => false
      t.string :url, :null => false
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :storages, :user_id
    add_index :storages, :created_at
  end
end
