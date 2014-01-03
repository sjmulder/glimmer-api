class CreateApps < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :slug,  :null => false
      t.string :title
      t.timestamps
    end

    add_index :apps, :slug, :unique => true
  end

  def down
    drop_table :apps
  end
end
