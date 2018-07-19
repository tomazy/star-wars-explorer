require 'test_helper'

class Api::RootControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_root_url, as: :json
    assert_equal 200, status
  end
end
