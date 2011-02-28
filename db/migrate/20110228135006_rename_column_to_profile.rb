class RenameColumnToProfile < ActiveRecord::Migration
  def self.up
    rename_column :profiles, :aniversary_date, :anniversary_date
  end

  def self.down
    rename_column :profiles, :anniversary_date, :aniversary_date
  end
end