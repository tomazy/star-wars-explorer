# frozen_string_literal: true

class Api::RootController < ApplicationController
  def show
    @root = {
      people: helpers.json_link_hash(api_people_path),
      planets: helpers.json_link_hash(api_planets_path),
      films: helpers.json_link_hash(api_films_path),
      species: helpers.json_link_hash('/api/species'),
      vehicles: helpers.json_link_hash('/api/vehicles'),
      starships: helpers.json_link_hash('/api/starships'),
    }
    render json: @root
  end
end
