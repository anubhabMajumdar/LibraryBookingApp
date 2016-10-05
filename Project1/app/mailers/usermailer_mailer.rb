class UsermailerMailer < ApplicationMailer
  default from: 'anubhabmajumdar93@gmail.com'

  def welcome_email(user)
    @email = user
    @url  = 'http://www.gmail.com'
    mail(to: @email, subject: 'Welcome to My Awesome Site')
  end

end
