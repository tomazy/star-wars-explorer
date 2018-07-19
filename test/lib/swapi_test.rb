# frozen_string_literal: true

require 'test_helper'

class SwapiCache::SwapiTest < ActiveSupport::TestCase
  # PEOPLE
  test 'fetches all people' do
    VCR.use_cassette 'people/all' do
      people = Swapi.all_people
      assert_kind_of Array, people
      assert_operator 10, :<, people.size
      assert_equal 'Luke Skywalker', people.first['name']
    end
  end

  test 'fetches a person' do
    VCR.use_cassette 'people/1' do
      person = Swapi.person 1
      assert_kind_of Hash, person
      assert_equal 'Luke Skywalker', person['name']
    end
  end

  # PLANETS
  test 'fetches all planets' do
    VCR.use_cassette 'planets/all' do
      planets = Swapi.all_planets
      assert_kind_of Array, planets
      assert_operator 10, :<, planets.size
      assert_equal 'Alderaan', planets.first['name']
    end
  end

  test 'fetches a planet' do
    VCR.use_cassette 'planets/1' do
      planet = Swapi.planet 1
      assert_kind_of Hash, planet
      assert_equal 'Tatooine', planet['name']
    end
  end

  # FILMS
  test 'fetches all films' do
    VCR.use_cassette 'films/all' do
      films = Swapi.all_films
      assert_kind_of Array, films
      assert_equal 'A New Hope', films.first['title']
      assert_operator 6, :<, films.size
    end
  end

  test 'fetches a film' do
    VCR.use_cassette 'films/1' do
      film = Swapi.film 1
      assert_kind_of Hash, film
      assert_equal 'A New Hope', film['title']
    end
  end
end
