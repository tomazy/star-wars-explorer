require 'test_helper'

class SwapiCache::FilmCacheTest < ActiveSupport::TestCase
  RESOURCE = 'films'

  FILM_1_ID = 10
  FILM_2_ID = 20

  FILM_1_JSON = {
    url: "/api/films/#{FILM_1_ID}",
    episode_id: 1,
    title: 'A New Hope',
  }.stringify_keys

  FILM_2_JSON = {
    url: "/api/films/#{FILM_2_ID}",
    episode_id: 5,
    title: 'A New Hope 2',
  }.stringify_keys

  ALL_FILMS_JSON = [
    FILM_1_JSON,
    FILM_2_JSON,
  ]

  setup do
    Film.delete_all
    CacheStatus.where(resource: RESOURCE).update(cached: false)
  end

  test 'caching films (miss) - populates the cache' do
    refute CacheStatus.find_by_resource(RESOURCE).cached
    assert_equal 0, Film.count

    Swapi.stub :all_films, ALL_FILMS_JSON do
      SwapiCache::FilmCache.ensure_films_cached
    end

    assert_equal ALL_FILMS_JSON.count, Film.count

    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching films (hit) - does not call the api' do
    CacheStatus.where(resource: RESOURCE).update(cached: true)

    mock = MiniTest::Mock.new
    Swapi.stub :all_films, mock do
      begin
        SwapiCache::FilmCache.ensure_films_cached
      rescue NoMethodError
        fail 'Swapi.all_films should not be called!'
      end
    end
  end

  test 'caching film (miss) - populates the cache' do
    resource_id = FILM_1_ID
    resource = "#{RESOURCE}/#{resource_id}"

    Swapi.stub :film, FILM_1_JSON, [resource_id] do
      SwapiCache::FilmCache.ensure_film_cached(resource_id)
    end

    assert_equal 1, Film.count

    film = Film.find resource_id
    assert_equal FILM_1_JSON['title'], film.title
    assert_equal FILM_1_JSON['episode_id'], film.episode_id

    assert CacheStatus.find_by_resource(resource).cached
  end
end
