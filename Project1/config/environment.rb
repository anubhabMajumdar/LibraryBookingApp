# Load the Rails application.
require_relative 'application'


# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do

config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => "anubhabmajumdar93@gmail.com",
    :password => "kcrevnflsfcbbvei",
    :authentication => :plain

}


end