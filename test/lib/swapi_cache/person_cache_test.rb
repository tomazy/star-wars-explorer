require 'test_helper'

class SwapiCache::PersonCacheTest < ActiveSupport::TestCase
  setup do
    Person.delete_all
    Planet.delete_all
    CacheStatus.where(resource: 'people').update(cached: false)
  end

  test 'caching people' do
    resource = 'people'

    VCR.use_cassette 'people/all' do
      SwapiCache::PersonCache.ensure_people_cached
    end

    refute_equal 0, Person.count
    refute_equal 0, Planet.count
    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'caching person' do
    resource_id = 1
    resource = "people/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    VCR.use_cassette "people/#{resource_id}" do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count
    assert_equal 1, Planet.count

    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'updating person cache' do
    resource_id = 1
    resource = "people/#{resource_id}"

    CacheStatus.where(resource: resource).update(cached: false)

    # Person could be created by a planet
    planet = Planet.create! id: 1
    Person.create! id: resource_id, planet: planet

    VCR.use_cassette "people/#{resource_id}" do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count
    assert_equal 1, Planet.count
    assert CacheStatus.find_by_resource(resource).cached

    person = Person.first
    assert_equal 'Luke Skywalker', person.name
  end
end
