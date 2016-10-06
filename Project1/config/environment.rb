# Load the Rails application.
require_relative 'application'


# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do

config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp

# config.action_mailer.smtp_settings = {
#     :enable_starttls_auto => true,
#     :address => "smtp.gmail.com",
#     :port => 587,
#     :domain => "gmail.com",
#     # :user_name => "anubhabmajumdar93@gmail.com",
#     # :password => "kcrevnflsfcbbvei",
#     :user_name => "librarybookingapp@gmail.com",
#     :password => "root@123",
#     :authentication => :plain
#
# }

# config.action_mailer.smtp_settings = {
#     :enable_starttls_auto => true,
#     :address => "smtp.mailgun.org",
#     :port => 587,
#     :domain => "sandbox62230d134e334f2c9859ed3c3dde8ddc.mailgun.org",
#     :user_name => "postmaster@sandbox62230d134e334f2c9859ed3c3dde8ddc.mailgun.org",
#     :password => "eb4e6cbbec84adc15a9cf51f5aacd496",
#     :authentication => :plain,
#     :openssl_verify_mode => 'none'
# }

  #  Production
  config.action_mailer.smtp_settings = {
      :enable_starttls_auto => true,
      :address => "smtp.mailgun.org",
      :port => 587,
      :domain => "appd6764188b5ba41fa832e9f4b490b6c88.mailgun.org",
      :user_name => "postmaster@appd6764188b5ba41fa832e9f4b490b6c88.mailgun.org",
      :password => "ebff1c5a5951216fb2f87547758cd627",
      :authentication => :plain,
      :openssl_verify_mode => 'none'
  }

  # config.action_mailer.smtp_settings = {
  #     :enable_starttls_auto => true,
  #     :address => "smtp.mailgun.org",
  #     :port => 587,
  #     :domain => "librarybookingapp.com",
  #     :user_name => "postmaster@librarybookingapp.com",
  #     :password => "6e28c10d0d9fd4be7e75ee533806560e",
  #     :authentication => :plain,
  #     :openssl_verify_mode => 'none'
  # }

end