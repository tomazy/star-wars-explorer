require 'test_helper'

class SwapiCacheTest < ActiveSupport::TestCase
  test 'caching planets' do
    Person.delete_all
    Planet.delete_all

    CacheStatus.where(resource: 'planets').update(cached: false)

    SwapiCache.ensure_planets_cached

    refute_equal 0, Planet.count
    refute_equal 0, Person.count
    assert CacheStatus.find_by_resource('planets').cached
  end
end
