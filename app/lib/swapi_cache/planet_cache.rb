class SwapiCache::PlanetCache < SwapiCache::Base
  class << self
    def ensure_planets_cached
      cache 'planets' do
        populate_many Swapi.all_planets
      end
    end

    def ensure_planet_cached(id)
      return if cached? 'planets'

      cache "planets/#{id}" do
        populate_one Swapi.planet(id)
      end
    end

    protected

    def populate_one(json)
      attrs = json.except 'residents', 'films', 'created', 'edited', 'url'

      planet = Planet.find_or_initialize_by(id: extract_id(json['url']))
      planet.assign_attributes attrs

      json_residents_ids = json['residents'].map { |url| extract_id(url) }
      json_residents_ids.each do |id|
        planet.residents.build id: id
      end

      planet.save!
    end
  end
end
