class CreateCacheStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :cache_statuses do |t|
      t.string :resource
      t.boolean :cached

      t.timestamps
    end
    add_index :cache_statuses, :resource, unique: true
  end
end
