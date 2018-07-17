class Planet < ApplicationRecord
  default_scope { order(id: :asc) }
  has_many :residents, class_name: Person.name
end
