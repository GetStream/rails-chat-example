require 'test_helper'

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get message" do
    get webhook_message_url
    assert_response :success
  end

end
