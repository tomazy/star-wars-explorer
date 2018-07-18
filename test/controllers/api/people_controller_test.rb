require 'test_helper'

class Api::PeopleControllerTest < ActionDispatch::IntegrationTest
  # index
  test "should get index" do
    get api_people_url, as: :json
    assert_response :success
  end

  test 'GET / - responds with all people as json' do
    get api_people_url, as: :json
    assert people.length > 0
    assert_equal people.length, response.parsed_body.size
    assert_equal people(:leia_organa).name, response.parsed_body[0]['name']
  end

  test 'GET / - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil)
    SwapiCache::PersonCache.stub :ensure_people_cached, mock do
      get api_people_url, as: :json
    end
    mock.verify
  end

  # show
  test "should get show" do
    get api_person_url(people(:leia_organa)), as: :json
    assert_response :success
  end

  test 'GET /:id - responds with the planet as json' do
    get api_person_url(people(:leia_organa)), as: :json
    assert_equal people(:leia_organa).name, response.parsed_body['name']
  end

  test 'GET /:id - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil, [people(:leia_organa).id])
    SwapiCache::PersonCache.stub :ensure_person_cached, mock do
      get api_person_url(people(:leia_organa)), as: :json
    end
    mock.verify
  end
end
