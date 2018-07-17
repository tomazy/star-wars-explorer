class Api::PeopleController < ApplicationController
  def index
    SwapiCache::PersonCache.ensure_people_cached
    @people = Person.all
  end

  def show
    id = params.require(:id).to_i
    SwapiCache::PersonCache.ensure_person_cached id
    @person = Person.find id
  end
end
