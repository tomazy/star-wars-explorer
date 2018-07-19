# frozen_string_literal: true

class SwapiCache::PersonCache < SwapiCache::Base
  class << self
    def ensure_people_cached
      cache 'people' do
        populate_many Swapi.all_people
      end
    end

    def ensure_person_cached(id)
      return if cached? 'people'

      cache "people/#{id}" do
        populate_one Swapi.person(id)
      end
    end

    protected

    def populate_one(json)
      attrs = json.except 'homeworld', 'films', 'species', 'vehicles', 'starships', \
                          'created', 'edited', 'url'

      person = Person.find_or_initialize_by(id: extract_id(json['url']))
      person.assign_attributes attrs

      person.planet = Planet.find_or_create_by(id: extract_id(json['homeworld']))
      person.save!
    end
  end
end
