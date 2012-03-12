class User < ActiveRecord::Base
    attr_accessible :name, :email, :password, :password_confirmation, :stripe_token, :last_4_digits, :camp_id, :dob, :lname, :addr1, :addr2, :city, :state, :zip, :admin

  belongs_to :camp
  has_one :billing_info
  accepts_nested_attributes_for :billing_info

  attr_accessor :password, :stripe_token, :stripe_camp_id
  attr_accessible :billing_info_attributes

  before_save :encrypt_password
  before_save :update_stripe
  after_create :resitration_notification

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :last_4_digits

  def stripe_description
    "#{name}: #{email}"
  end
 
  def is_admin?
    admin
  end

  def update_stripe
    if stripe_id.nil?
      if !stripe_token.present?
        raise "We're doing something wrong -- this isn't supposed to happen"
      end

      customer = Stripe::Customer.create(
        :email => email,
        :description => stripe_description,
        :card => stripe_token
      )
      self.last_4_digits = customer.active_card.last4
      response = customer.update_subscription({:plan => stripe_camp_id})
    else
      customer = Stripe::Customer.retrieve(stripe_id)

      if stripe_token.present?
        customer.card = stripe_token
      end

      # in case they've changed
      customer.email = email
      customer.description = stripe_description

      customer.save

      self.last_4_digits = customer.active_card.last4
    end

    self.stripe_id = customer.id
    self.stripe_token = nil
  end

  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user && BCrypt::Password.new(user.hashed_password) == password
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.hashed_password = BCrypt::Password.create(password)
    end
  end
  
  def resitration_notification
    UserMailer.resitration_successfully(self).deliver
    unless (users = User.where(:admin => true)).blank?
      users.each do |user|
        UserMailer.new_resitration(user, self).deliver
      end
    end
  end

end
