require 'test_helper'

class Api::RootControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_root_url
    assert_response :success
  end
end
