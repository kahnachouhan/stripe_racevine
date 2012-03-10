class CreateBillingInfos < ActiveRecord::Migration
  def self.up
    create_table :billing_infos do |t|
      t.datetime :dob
      t.string :addr1
      t.string :addr2
      t.string :city
      t.string :state
      t.string :zip
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billing_infos
  end
end
