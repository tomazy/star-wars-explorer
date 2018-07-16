require 'open-uri'

class Swapi
  class << self
    def all_planets
      all_resources 'planets'
    end

    private

    BASE_URL = 'https://swapi.co/api'

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
