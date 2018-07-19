# frozen_string_literal: true

class Api::FilmsController < ApplicationController
  def index
    SwapiCache::FilmCache.ensure_films_cached
    @films = Film.all
  end

  def show
    id = params.require(:id).to_i
    SwapiCache::FilmCache.ensure_film_cached id
    @film = Film.find id
  end
end
