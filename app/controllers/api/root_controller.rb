class Api::RootController < ApplicationController
  def show
    @root = {
      people: helpers.json_link_hash(api_people_path),
      planets: helpers.json_link_hash(api_planets_path),
      films: helpers.json_link_hash(api_films_path),
      species: '/api/species',
      vehicles: '/api/vehicles',
      starships:'/api/starships',
    }
    render json: @root
  end
end
