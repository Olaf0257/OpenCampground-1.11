class Tabs < ActiveRecord::Migration
  def self.up
    add_column :options, :tabs, :boolean, :default => false
  end

  def self.down
    remove_column :options, :tabs
  end
end
