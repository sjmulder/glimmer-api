class CreateReleases < ActiveRecord::Migration
  def up
    create_table :releases do |t|
      t.integer :app_id,            :null => false
      t.integer :version,           :null => false
      t.string  :version_string
      t.string  :bundle_identifier, :null => false
      t.string  :package_url,       :null => false
      t.string  :icon_url
      t.boolean :icon_needs_shine,                  :default => true
      t.string  :artwork_url
      t.boolean :artwork_needs_shine,               :default => true
      t.text    :release_notes_html
      t.timestamps
    end

    add_index :releases, [:app_id, :version], :unique => true
  end

  def down
    drop_table :releases
  end
end
