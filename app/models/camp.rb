class Camp < ActiveRecord::Base
  
  has_many :users, :dependent=> :nullify
  has_many :billing_infos, :through => :users

end
