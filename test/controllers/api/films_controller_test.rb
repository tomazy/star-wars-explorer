# frozen_string_literal: true

require 'test_helper'

class Api::FilmsControllerTest < ActionDispatch::IntegrationTest
  # index
  test 'GET / - works' do
    get api_films_url, as: :json
    assert_equal 200, status
  end

  test 'GET / - responds with all films as json' do
    get api_films_url, as: :json
    assert_operator 0, :<, films.length
    assert_equal films.length, response.parsed_body.size
    assert_equal films(:episode_4).title, response.parsed_body[0]['title']
    assert_equal films(:episode_5).title, response.parsed_body[1]['title']
  end

  test 'GET / - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil)
    SwapiCache::FilmCache.stub :ensure_films_cached, mock do
      get api_films_url, as: :json
    end
    mock.verify
  end

  # show
  test 'GET /:id - works' do
    get api_film_url(films(:episode_4)), as: :json
    assert_equal 200, status
  end

  test 'GET /:id - responds with the planet as json' do
    get api_film_url(films(:episode_5)), as: :json
    assert_equal films(:episode_5).title, response.parsed_body['title']
  end

  test 'GET /:id - ensures the cache is populated' do
    mock = MiniTest::Mock.new
    mock.expect(:call, nil, [films(:episode_5).id])
    SwapiCache::FilmCache.stub :ensure_film_cached, mock do
      get api_film_url(films(:episode_5)), as: :json
    end
    mock.verify
  end
end
