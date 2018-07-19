# frozen_string_literal: true

class SwapiCache::FilmCache < SwapiCache::Base
  class << self
    def ensure_films_cached
      cache 'films' do
        populate_many Swapi.all_films
      end
    end

    def ensure_film_cached(id)
      return if cached? 'films'

      cache "films/#{id}" do
        populate_one Swapi.film(id)
      end
    end

    protected

    def populate_one(json)
      attrs = json.except 'characters', 'planets', 'starships', 'vehicles', 'species', \
                          'created', 'edited', 'url'

      film = Film.find_or_initialize_by(id: extract_id(json['url']))
      film.assign_attributes attrs

      film.save!
    end
  end
end
