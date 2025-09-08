class PasswordsController < Devise::PasswordsController
  # Override the create action to prevent email enumeration
  def create
    email = params[:user][:email] if params[:user]
    
    if email.present?
      # Check if user exists
      user = User.find_by(email: email)
      
      if user
        # User exists, send reset instructions
        user.send_reset_password_instructions
        flash[:notice] = "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes."
      else
        # User doesn't exist, but show the same message for security
        flash[:notice] = "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes."
      end
    else
      flash[:alert] = "Email address is required."
    end
    
    # Always redirect to the same page regardless of whether user exists
    redirect_to new_user_password_path
  end
end
