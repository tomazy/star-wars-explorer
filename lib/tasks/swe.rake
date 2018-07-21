namespace :swe do
  desc 'Clear SWAPI cache'
  task clear_swapi_cache: :environment do
    Film.delete_all
    Person.delete_all
    Planet.delete_all
    CachedResource.delete_all
  end
end
