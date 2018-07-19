require 'test_helper'

class SwapiCache::PersonCacheTest < ActiveSupport::TestCase
  RESOURCE = 'people'

  PERSON_1_ID = 100
  PERSON_2_ID = 200
  PERSON_3_ID = 300

  PLANET_1_ID = 10
  PLANET_2_ID = 20

  PERSON_1_JSON = {
    url: "/api/people/#{PERSON_1_ID}",
    name: 'Luke Skywalker',
    gender: 'male',
    homeworld: "/api/planets/#{PLANET_1_ID}"
  }.stringify_keys

  PERSON_2_JSON = {
    url: "/api/people/#{PERSON_2_ID}",
    name: 'Leia Organa',
    gender: 'female',
    homeworld: "/api/planets/#{PLANET_2_ID}"
  }.stringify_keys

  PERSON_3_JSON = {
    url: "/api/people/#{PERSON_3_ID}",
    name: 'Darth Vader',
    gender: 'male',
    homeworld: "/api/planets/#{PLANET_1_ID}"
  }.stringify_keys

  ALL_PEOPLE_JSON = [
    PERSON_1_JSON,
    PERSON_2_JSON,
    PERSON_3_JSON,
  ]

  setup do
    Person.delete_all
    Planet.delete_all
    Film.delete_all
    CacheStatus.where(resource: RESOURCE).update(cached: false)
  end

  test 'caching people (miss) - populates the cache' do
    refute CacheStatus.find_by_resource(RESOURCE).cached

    Swapi.stub :all_people, ALL_PEOPLE_JSON do
      SwapiCache::PersonCache.ensure_people_cached
    end

    assert_equal ALL_PEOPLE_JSON.count, Person.count

    uniq_planets_urls = ALL_PEOPLE_JSON.map{ |h| h['homeworld'] }.sort.uniq
    assert_equal uniq_planets_urls.count, Planet.count

    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching people (hit) - does not call the api' do
    CacheStatus.where(resource: RESOURCE).update(cached: true)

    mock = MiniTest::Mock.new
    Swapi.stub :all_people, mock do
      begin
        SwapiCache::PersonCache.ensure_people_cached
      rescue NoMethodError
        fail 'Swapi.all_people should not be called!'
      end
    end
  end

  test 'caching person (miss) - populates the cache' do
    resource_id = PERSON_1_ID
    resource = "#{RESOURCE}/#{resource_id}"

    Swapi.stub :person, PERSON_1_JSON, [resource_id] do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count

    person = Person.find resource_id
    assert_equal PERSON_1_JSON['name'], person.name
    assert_equal PERSON_1_JSON['gender'], person.gender
    assert_equal PLANET_1_ID, person.planet.id

    assert_equal 1, Planet.count

    planet = Planet.find PLANET_1_ID
    assert_nil planet.name

    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'updating person cache (miss) - updates existing record' do
    resource_id = PERSON_2_ID
    resource = "#{RESOURCE}/#{resource_id}"

    # A case when the person placeholder was created by the planet
    planet = Planet.create! id: PLANET_2_ID
    Person.create! id: resource_id, planet: planet

    Swapi.stub :person, PERSON_2_JSON do
      SwapiCache::PersonCache.ensure_person_cached(resource_id)
    end

    assert_equal 1, Person.count

    person = Person.first
    assert_equal PERSON_2_JSON['name'], person.name
    assert_equal PERSON_2_JSON['gender'], person.gender

    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'caching person (hit) - does not call the api' do
    resource_id = PERSON_1_ID
    resource = "#{RESOURCE}/#{resource_id}"

    CacheStatus.create! resource: resource, cached: true

    mock = MiniTest::Mock.new
    Swapi.stub :person, mock do
      begin
        SwapiCache::PersonCache.ensure_person_cached(resource_id)
      rescue NoMethodError
        fail 'Swapi.person should not be called!'
      end
    end
  end
end
