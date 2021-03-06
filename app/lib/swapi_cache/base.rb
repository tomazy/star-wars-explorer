# frozen_string_literal: true

class SwapiCache::Base
  class << self
    protected

    def cached?(resource)
      CachedResource.find_by(resource: resource).present?
    end

    def cache(resource, &block)
      return if cached? resource

      yield

      CachedResource.create! resource: resource
    end

    def extract_id(url)
      url.split('/').last.to_i
    end

    def populate_many(json_array)
      json_array.each do |json|
        populate_one json
      end
    end

    def populate_one(_json)
      raise 'Not implemented!'
    end
  end
end
