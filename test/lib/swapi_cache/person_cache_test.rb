require 'test_helper'

class SwapiCache::PersonCacheTest < ActiveSupport::TestCase
  RESOURCE = 'people'

  setup do
    Person.delete_all
    Planet.delete_all
    CacheStatus.where(resource: 'people').update(cached: false)
  end

  test 'caching people' do
    VCR.use_cassette "#{RESOURCE}/all" do
      SwapiCache::PersonCache.ensure_people_cached
    end

    refute_equal 0, Person.count
    refute_equal 0, Planet.count
    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching person' do
    resource_id = 1
    resource = "#{RESOURCE}/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    VCR.use_cassette resource do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count
    assert_equal 1, Planet.count

    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'updating person cache' do
    resource_id = 1
    resource = "#{RESOURCE}/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    # Person was created by a planet
    planet = Planet.create! id: 1
    Person.create! id: resource_id, planet: planet

    VCR.use_cassette resource do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count
    assert_equal 1, Planet.count
    assert CacheStatus.find_by_resource(resource).cached

    person = Person.first
    assert_equal 'Luke Skywalker', person.name
  end
end
