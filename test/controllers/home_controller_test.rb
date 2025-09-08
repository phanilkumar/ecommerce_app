require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should redirect to login when not authenticated" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end
end
