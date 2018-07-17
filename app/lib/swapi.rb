require 'open-uri'

class Swapi
  class << self
    def all_planets
      all_resources 'planets'
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

      while true do
        json = fetch_json query

        results += json['results']

        query = json['next']

        break if query.blank?
      end

      results
    end

    def fetch_json(url)
      res = open(url, 'User-Agent' => 'swapi-ruby').read
      JSON.load(res)
    end
  end
end
