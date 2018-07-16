require 'test_helper'

class Api::PlanetsControllerTest < ActionDispatch::IntegrationTest
  # index
  test 'GET /' do
    get api_planets_url, as: :json
    assert_equal 200, status
  end

  test 'GET / - responds with all planets as json' do
    get api_planets_url, as: :json
    assert planets.length > 0
    assert_equal planets.length, response.parsed_body.size
    assert_equal planets(:alderaan).name, response.parsed_body[0]['name']
    assert_equal planets(:hoth).name, response.parsed_body[1]['name']
  end

  test 'GET / - planets have links to residents' do
    get api_planets_url, as: :json
    alderaan = response.parsed_body[0]
    assert alderaan['residents'].length > 0

    resident = alderaan['residents'].sample
    refute_empty resident['_href']
    refute_empty resident['_text']
  end

  test 'GET / - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil)
    SwapiCache.stub :ensure_planets_cached, mock do
      get api_planets_url, as: :json
    end
    mock.verify
  end

  # show
  test 'GET /:id' do
    get api_planet_url(planets(:hoth)), as: :json
    assert_equal 200, status
  end

  test 'GET /:id - responds with the planet as json' do
    get api_planet_url(planets(:hoth)), as: :json
    assert_equal planets(:hoth).name, response.parsed_body['name']
  end

  test 'GET /:id - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil, [planets(:hoth).id])
    SwapiCache.stub :ensure_planet_cached, mock do
      get api_planet_url(planets(:hoth)), as: :json
    end
    mock.verify
  end
end