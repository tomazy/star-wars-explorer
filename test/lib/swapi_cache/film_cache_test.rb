require 'test_helper'

class SwapiCache::FilmCacheTest < ActiveSupport::TestCase
  RESOURCE = 'films'

  setup do
    Film.delete_all
    CacheStatus.where(resource: RESOURCE).update(cached: false)
  end

  test 'caching films' do
    VCR.use_cassette "#{RESOURCE}/all" do
      SwapiCache::FilmCache.ensure_films_cached
    end

    refute_equal 0, Film.count
    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching film' do
    resource_id = 1
    resource = "#{RESOURCE}/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    VCR.use_cassette resource do
      SwapiCache::FilmCache.ensure_film_cached(resource_id)
    end

    assert_equal 1, Film.count

    assert CacheStatus.find_by_resource(resource).cached
  end
end
