class UsermailerMailer < ApplicationMailer
  default from: 'librarybookingapp@gmail.com'

  def welcome_email(user)
    @email = user
    @url  = 'http://www.gmail.com'
    mail(to: @email, subject: 'Welcome to My Awesome Site')
  end

  def notification_email(booking, receiver)
    @b = booking
    mail(to: receiver, subject: 'Room book information')

  end

end
