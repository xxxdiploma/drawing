class CreateArticles < ActiveRecord::Migration

  def self.up
    create_table :articles do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
    add_index :articles, :user_id
    add_index :articles, :created_at
  end

  def self.down
    drop_table :articles
  end

end
