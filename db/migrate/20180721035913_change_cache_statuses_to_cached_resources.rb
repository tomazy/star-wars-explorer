class ChangeCacheStatusesToCachedResources < ActiveRecord::Migration[5.2]
  def change
    remove_index :cache_statuses, :resource
    rename_table :cache_statuses, :cached_resources
    add_index :cached_resources, :resource, unique: true
  end
end
