class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :dob, :datetime
    add_column :users, :lname, :string    
    add_column :users, :addr1, :string
    add_column :users, :addr2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
  end

  def self.down
    remove_column :users, :dob
    remove_column :users, :lname
    remove_column :users, :addr1
    remove_column :users, :addr2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip
  end
end
