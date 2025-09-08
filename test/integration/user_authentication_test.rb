require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "should allow user to sign up" do
    get new_user_registration_path
    assert_response :success
    
    post user_registration_path, params: {
      user: {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
    
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should allow user to sign in and sign out" do
    # Create a user first
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    # Sign in
    get new_user_session_path
    assert_response :success
    
    post user_session_path, params: {
      user: {
        email: "test@example.com",
        password: "password123"
      }
    }
    
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    
    # Sign out
    delete destroy_user_session_path
    assert_redirected_to root_path
  end
end
