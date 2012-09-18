class AddUidForStorages < ActiveRecord::Migration
  def up
    add_column :storages, :uid, :integer
  end

  def down
    remove_column :storages, :uid
  end
end
