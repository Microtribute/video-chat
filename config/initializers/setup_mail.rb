#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :domain => "gmail.com",
#  :user_name => "nasalupani",
#  :password => "ambrosia977",
#  :authentication => "plain",
#  :enable_starttls_auto => true
#}
ActionMailer::Base.default_url_options[:host] = "lawdingo.com"

ActionMailer::Base.smtp_settings = {
 :user_name => "lawdingo",
 :password => "dingobaby9",
 :domain => "lawdingo.com",
 :address => "smtp.sendgrid.net",
 :port => 587,
 :authentication => :plain,
 :enable_starttls_auto => true
}

