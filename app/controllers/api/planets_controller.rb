class Api::PlanetsController < ApplicationController
  def index
    SwapiCache.ensure_planets_cached
    @planets = Planet.all
  end

  def show
    id = params.require(:id).to_i
    SwapiCache.ensure_planet_cached id
    @planet = Planet.find id
  end
end
