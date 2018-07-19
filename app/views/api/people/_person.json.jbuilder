# frozen_string_literal: true

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
  json.merge! json_link_hash(api_planet_path(person.planet))
end
json.url do
  json.merge! json_link_hash(api_person_path(person))
end
