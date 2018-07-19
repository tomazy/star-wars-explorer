require 'test_helper'

class SwapiCache::PlanetCacheTest < ActiveSupport::TestCase
  RESOURCE = 'planets'

  PLANET_1_ID = 100
  PLANET_2_ID = 200

  PLANET_2_RESIDENT_ID_1 = 30

  PLANET_1_JSON = {
    url: "/api/people/#{PLANET_1_ID}",
    rotation_period: '12',
    name: 'Earth',
    residents: [
      'https://swapi.co/api/people/10/',
      'https://swapi.co/api/people/20/',
    ]
  }.stringify_keys

  PLANET_2_JSON = {
    url: "/api/people/#{PLANET_2_ID}",
    rotation_period: '13',
    name: 'Mars',
    residents: [
      "https://swapi.co/api/people/#{PLANET_2_RESIDENT_ID_1}/",
      'https://swapi.co/api/people/40/',
      'https://swapi.co/api/people/50/',
    ]
  }.stringify_keys

  ALL_PLANETS_JSON = [
    PLANET_1_JSON,
    PLANET_2_JSON,
  ]

  setup do
    Person.delete_all
    Planet.delete_all
    CacheStatus.where(resource: 'planets').update(cached: false)
  end

  test 'caching planets (miss) - populates the cache' do
    Swapi.stub :all_planets, ALL_PLANETS_JSON do
      SwapiCache::PlanetCache.ensure_planets_cached
    end

    assert_equal ALL_PLANETS_JSON.count, Planet.count

    assert_operator 0, :<, Person.count

    uniq_people_urls = ALL_PLANETS_JSON.map{ |h| h['residents'] }.reduce(:+).sort.uniq
    assert_equal uniq_people_urls.count, Person.count

    assert CacheStatus.find_by_resource(RESOURCE).cached
  end

  test 'caching planets (hit) - does not call the api' do
    CacheStatus.where(resource: RESOURCE).update(cached: true)

    mock = MiniTest::Mock.new
    Swapi.stub :all_planets, mock do
      begin
        SwapiCache::PlanetCache.ensure_planets_cached
      rescue NoMethodError
        fail 'Swapi.all_planets should not be called!'
      end
    end
  end

  test 'caching planet (miss) - populates the cache' do
    resource_id = PLANET_1_ID
    resource = "#{RESOURCE}/#{resource_id}"

    Swapi.stub :planet, PLANET_1_JSON, [resource_id] do
      SwapiCache::PlanetCache.ensure_planet_cached(resource_id)
    end

    assert_equal 1, Planet.count

    assert_operator 0, :<, Person.count
    assert_equal PLANET_1_JSON['residents'].size, Person.count

    assert CacheStatus.find_by_resource(resource).cached
  end

  test 'updating planet cache (miss) - updates existing record' do
    resource_id = PLANET_2_ID
    resource = "#{RESOURCE}/#{resource_id}"

    # A case when the planet placeholder already exists.
    # This happens when we visit a person whose homeworld is this planet and then
    # visit the planet.
    # [empty cache] -> people -> planets/1
    Planet.create! id: resource_id
    Person.create! id: PLANET_2_RESIDENT_ID_1, planet_id: resource_id

    Swapi.stub :planet, PLANET_2_JSON, [resource_id] do
      SwapiCache::PlanetCache.ensure_planet_cached(resource_id)
    end

    assert_equal 1, Planet.count

    planet = Planet.find resource_id
    assert_equal PLANET_2_JSON['name'], planet.name
    assert_equal PLANET_2_JSON['rotation_period'], planet.rotation_period
    assert_equal PLANET_2_JSON['residents'].count, Person.count

    assert CacheStatus.find_by_resource(resource).cached
  end
end
