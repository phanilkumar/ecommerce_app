class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    result = User.from_omniauth(request.env['omniauth.auth'])
    @user = result[:user]
    status = result[:status]
    oauth_source = request.env['omniauth.params']['oauth_source'] # Get the source from OAuth params

    if @user.persisted?
      case status
      when :existing
        # User already exists with this OAuth provider
        if oauth_source == 'signup'
          # User tried to sign up but account already exists - redirect to login
          flash[:alert] = "An account with this email already exists. Please sign in with Google instead."
          redirect_to new_user_session_path
        else
          # User is signing in normally
          flash[:notice] = "Welcome back! You're already signed in with Google."
          sign_in_and_redirect @user, event: :authentication
        end
      when :updated
        # Existing user account was updated with OAuth info
        flash[:notice] = "Your account has been successfully linked with Google. You can now sign in with Google in the future."
        sign_in_and_redirect @user, event: :authentication
      when :new
        # New user account created
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      end
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  rescue => e
    Rails.logger.error "OAuth error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    redirect_to new_user_registration_url, alert: "Authentication failed. Please try again."
  end


  def failure
    redirect_to root_path
  end
end



