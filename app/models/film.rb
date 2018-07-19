# frozen_string_literal: true

class Film < ApplicationRecord
  default_scope { order(id: :asc) }
end
