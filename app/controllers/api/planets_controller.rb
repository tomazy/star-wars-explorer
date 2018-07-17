class Api::PlanetsController < ApplicationController
  def index
    SwapiCache::PlanetCache.ensure_planets_cached
    @planets = Planet.all
  end

  def show
    id = params.require(:id).to_i
    SwapiCache::PlanetCache.ensure_planet_cached id
    @planet = Planet.find id
  end
end
