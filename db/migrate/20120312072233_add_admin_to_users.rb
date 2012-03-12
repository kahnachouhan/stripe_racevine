class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    User.skip_callback(:save, :before, :update_stripe)
    User.skip_callback(:create, :after, :resitration_notification)
    user1 = User.new(:name=>"admin", :email=>"gregory.lou@gmail.com
",:password=>"123456", :password_confirmation=>"123456", :last_4_digits=>"3456",:stripe_token=>"qwertytt", :admin => true)
    user1.save
    user2 = User.new(:name=>"kahna", :email=>"kahnachouhan@gmail.com",:password=>"123456", :password_confirmation=>"123456", :last_4_digits=>"3456",:stripe_token=>"qwertytta", :admin => true)
    user2.save
    User.set_callback(:save, :before, :update_stripe)
    User.set_callback(:create, :after, :resitration_notification)
  end

  def self.down
  end
end
