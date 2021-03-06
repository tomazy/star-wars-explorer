# frozen_string_literal: true

require 'open-uri'

class Swapi
  class << self
    def all_films
      all_resources 'films'
    end

    def all_people
      all_resources 'people'
    end

    def all_planets
      all_resources 'planets'
    end

    def film(id)
      fetch_json resource_url('films', id)
    end

    def person(id)
      fetch_json resource_url('people', id)
    end

    def planet(id)
      fetch_json resource_url('planets', id)
    end

    private

    BASE_URL = 'https://swapi.co/api'

    def resource_url(resource_name, resource_id)
      "#{BASE_URL}/#{resource_name}/#{resource_id}/"
    end

    def all_resources(name)
      results = []

      query = "#{BASE_URL}/#{name}"

      loop do
        json = fetch_json query

        results += json['results']

        query = json['next']

        break if query.blank?
      end

      results
    end

    def fetch_json(url)
      Rails.logger.debug "Swapi.fetch_json('#{url}')"
      res = open(url, 'User-Agent' => 'swapi-ruby').read
      JSON.load(res)
    end
  end
end
