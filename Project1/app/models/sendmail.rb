class Sendmail < ActionMailer::Base
  default from: "amajumd@ncsu.edu"

  def sample_email(mailid)
    mail(to: mailid, subject: 'Sample Email')
  end


end
