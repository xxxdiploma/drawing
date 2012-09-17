class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id, :null => false      
      t.text    :content

      t.timestamps
    end
    add_index :articles, :user_id
    add_index :articles, :created_at
  end
end
