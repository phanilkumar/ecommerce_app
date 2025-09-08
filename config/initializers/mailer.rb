# Mailer configuration for different environments
if Rails.env.development?
  # Use letter_opener gem for development email preview
  # Add 'gem "letter_opener"' to your Gemfile and run bundle install
  # Then uncomment the line below:
  # ActionMailer::Base.delivery_method = :letter_opener
  
  # For now, we'll use file delivery for development
  ActionMailer::Base.delivery_method = :file
  ActionMailer::Base.file_settings = { location: Rails.root.join('tmp/mail') }
elsif Rails.env.production?
  # Production email configuration
  ActionMailer::Base.delivery_method = :smtp
  
  # SMTP settings - these should be configured via environment variables or Rails credentials
  ActionMailer::Base.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', 'smtp.gmail.com'),
    port: ENV.fetch('SMTP_PORT', 587),
    domain: ENV.fetch('SMTP_DOMAIN', 'yourdomain.com'),
    user_name: ENV.fetch('SMTP_USERNAME', Rails.application.credentials.dig(:smtp, :user_name)),
    password: ENV.fetch('SMTP_PASSWORD', Rails.application.credentials.dig(:smtp, :password)),
    authentication: ENV.fetch('SMTP_AUTHENTICATION', 'plain'),
    enable_starttls_auto: ENV.fetch('SMTP_ENABLE_STARTTLS_AUTO', 'true') == 'true'
  }
  
  # Raise delivery errors in production
  ActionMailer::Base.raise_delivery_errors = true
  
  # Set default URL options for production
  ActionMailer::Base.default_url_options = {
    host: ENV.fetch('MAILER_HOST', 'yourdomain.com'),
    protocol: 'https'
  }
end
