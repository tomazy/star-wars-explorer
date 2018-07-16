class Api::RootController < ApplicationController
  def show
    @root = {
      planets: make_link('/api/planets', 'planets'),
      people: make_link('/api/people', 'people'),
      films: make_link('/api/films', 'films'),
      species: make_link('/api/species', 'species'),
      vehicles: make_link('/api/vehicles', 'vehicles'),
      starships: make_link('/api/starships', 'starships'),
    }
    render json: @root
  end

  private

  def make_link(href, text)
    { _href: href, _text: text }
  end
end
