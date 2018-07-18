require 'test_helper'

class SwapiCache::PlanetCacheTest < ActiveSupport::TestCase
  RESOURCE = 'planets'

  setup do
    Person.delete_all
    Planet.delete_all
    CacheStatus.where(resource: 'planets').update(cached: false)
  end

  test 'caching planets' do
    VCR.use_cassette "#{RESOURCE}/all" do
      SwapiCache::PlanetCache.ensure_planets_cached
    end

    refute_equal 0, Planet.count
    refute_equal 0, Person.count
    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching planet' do
    resource_id = 1
    resource = "#{RESOURCE}/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    VCR.use_cassette resource do
      SwapiCache::PlanetCache.ensure_planet_cached(resource_id)
    end

    assert_equal 1, Planet.count
    assert_equal 10, Person.count
    assert CacheStatus.find_by_resource(resource).cached
  end
end
