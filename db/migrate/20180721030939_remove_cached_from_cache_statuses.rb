class RemoveCachedFromCacheStatuses < ActiveRecord::Migration[5.2]
  def change
    remove_column :cache_statuses, :cached, :boolean
  end
end
