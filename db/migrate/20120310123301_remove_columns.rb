class RemoveColumns < ActiveRecord::Migration
  def self.up
    remove_column :billing_infos, :dob
  end

  def self.down
  end
end
