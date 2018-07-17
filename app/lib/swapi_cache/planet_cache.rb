class SwapiCache::PlanetCache < SwapiCache::Base
  class << self
    def ensure_planets_cached
      status = CacheStatus.where(resource: 'planets').first_or_initialize
      return if status.cached

      populate_many Swapi.all_planets

      status.cached = true
      status.save!
    end

    def ensure_planet_cached(id)
      # 1. If we have all planets then we are good to go!
      status = CacheStatus.where(resource: 'planets').first_or_initialize
      return if status.cached

      # 2. Otherwise - check this individual one.
      status = CacheStatus.where(resource: "planets/#{id}").first_or_initialize
      return if status.cached

      populate_one Swapi.planet(id)

      status.cached = true
      status.save!
    end

    protected

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
