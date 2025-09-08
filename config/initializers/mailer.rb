# Mailer configuration for development
if Rails.env.development?
  # Use letter_opener gem for development email preview
  # Add 'gem "letter_opener"' to your Gemfile and run bundle install
  # Then uncomment the line below:
  # ActionMailer::Base.delivery_method = :letter_opener
  
  # For now, we'll use file delivery for development
  ActionMailer::Base.delivery_method = :file
  ActionMailer::Base.file_settings = { location: Rails.root.join('tmp/mail') }
end
