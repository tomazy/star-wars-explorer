class Api::RootController < ApplicationController
  def show
    @root = {
      planets: helpers.json_link_hash('/api/planets'),
      people: helpers.json_link_hash('/api/people'),
      films: '/api/films',
      species: '/api/species',
      vehicles: '/api/vehicles',
      starships:'/api/starships',
    }
    render json: @root
  end
end
