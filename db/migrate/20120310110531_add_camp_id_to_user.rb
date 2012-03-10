class AddCampIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :camp_id, :integer    
  end

  def self.down
    add_column :users, :camp_id
  end
end
