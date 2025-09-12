class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  # Method to create user from OAuth data
  def self.from_omniauth(auth)
    # First, try to find user by provider and uid
    user = where(provider: auth.provider, uid: auth.uid).first
    
    if user
      return user
    end
    
    # If not found by provider/uid, try to find by email
    user = where(email: auth.info.email).first
    
    if user
      # Update existing user with OAuth info
      user.update!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        image: auth.info.image
      )
      return user
    end
    
    # Create new user
    create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.provider = auth.provider
      user.uid = auth.uid
      # Skip email confirmation for OAuth users
      user.skip_confirmation!
    end
  end
end
