class UserMailer < ActionMailer::Base
  default :from => "kahnachouhan@gmail.com"

  def resitration_successfully(user)
    mail(:to => user.email, :subject => "Registered Successfully", :body => "Your suscription has been successfully completed for camp: #{user.camp.name rescue ''}")
  end
 
  def new_resitration(admin, user)
    mail(:to => admin.email, :subject => "New Registration", :body => "#{user.email.to_s} has registered for camp: #{user.camp.name rescue ''}")
  end

end

