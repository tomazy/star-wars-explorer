class Film < ApplicationRecord
  default_scope { order(id: :asc) }
end
