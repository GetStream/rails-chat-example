require 'test_helper'

class SetupControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get setup_new_url
    assert_response :success
  end

  test "should get create" do
    get setup_create_url
    assert_response :success
  end

end
