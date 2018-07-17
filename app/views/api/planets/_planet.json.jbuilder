json.extract! planet,
  :name,
  :rotation_period,
  :orbital_period,
  :diameter,
  :climate,
  :gravity,
  :terrain,
  :surface_water,
  :population
json.residents planet.residents.map do |person|
  json.merge! json_link_hash(api_person_path(person), api_person_path(person))
end
