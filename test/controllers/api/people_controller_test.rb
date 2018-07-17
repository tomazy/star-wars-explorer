require 'test_helper'

class Api::PeopleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_people_url, as: :json
    assert_response :success
  end

  test "should get show" do
    get api_person_url(people(:leia_organa).id), as: :json
    assert_response :success
  end
end
