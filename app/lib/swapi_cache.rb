class SwapiCache
  class << self
    def ensure_planets_cached
      status = CacheStatus.where(resource: 'planets').first_or_initialize
      return if status.cached

      PlanetPopulator.new.populate_many Swapi.all_planets

      status.cached = true
      status.save!
    end

    def ensure_planet_cached(id)
      # raise 'Not implemented'
    end

    private

    class BasePopulator
      def extract_id(url)
        url.split('/').last.to_i
      end

      def populate_many(json_array)
        json_array.take(3).each do |json|
          populate_one json
        end
      end

      def populate_one(json)
        raise 'Not implemented'
      end
    end

    class PlanetPopulator < BasePopulator
      def populate_one(json)
        attrs = json.except 'residents', 'films', 'created', 'edited', 'url'
        attrs['id'] = extract_id json['url']

        planet = Planet.new attrs

        json_residents_ids = json['residents'].map { |url| extract_id(url) }
        json_residents_ids.each do |id|
          planet.residents.build id: id
        end

        planet.save!
      end
    end
  end
end
