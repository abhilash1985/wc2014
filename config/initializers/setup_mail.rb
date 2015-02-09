ActionMailer::Base.smtp_settings = {
  # :address        => "smtp.revenuemed.com",
  # :port           => 25,
  # :domain         => "revenuemed.com",
  # :enable_starttls_auto => true
  :authentication => :login,
  :user_name      => "vabhilash1985",
  :password       => "abhilash123",
  :address => "smtp.gmail.com",
  :port           => 587,
  :domain         => "gmail.com",
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options =  { :host => 'http://localhost:3000' }

Mail.defaults do
  retriever_method :pop3, :address    => "pop.gmail.com",
  :port       => 995,
  :user_name  => 'vabhilash1985',
  :password   => 'abhilash123',
  :enable_ssl => true
end