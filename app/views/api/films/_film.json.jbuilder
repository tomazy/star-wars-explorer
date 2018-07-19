# frozen_string_literal: true

json.extract! film,
              :title,
              :episode_id,
              :opening_crawl,
              :director,
              :producer,
              :release_date
json.url do
  json.merge! json_link_hash(api_film_path(film))
end
