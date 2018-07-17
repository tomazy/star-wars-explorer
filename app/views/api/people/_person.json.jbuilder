json.extract! person,
  :name,
  :height,
  :mass,
  :hair_color,
  :skin_color,
  :eye_color,
  :birth_year,
  :gender
json.homeworld do
  json.merge! json_link_hash(api_planet_path(person.planet), api_planet_path(person.planet))
end
