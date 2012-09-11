class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.integer :user_id
      t.string :file_name
      t.string :url
      t.text :description

      t.timestamps
    end
    add_index :storages, :user_id
    add_index :storages, :created_at
  end
end
