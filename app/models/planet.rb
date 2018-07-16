class Planet < ApplicationRecord
  has_many :residents, class_name: Person.name
end
