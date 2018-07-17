class Person < ApplicationRecord
  default_scope { order(id: :asc) }
  belongs_to :planet
end
