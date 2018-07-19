# frozen_string_literal: true

class SwapiCache::Base
  class << self
    protected

    def cached?(resource)
      status = CacheStatus.where(resource: resource).first
      status.present? && status.cached?
    end

    def cache(resource, &block)
      status = CacheStatus.find_or_initialize_by(resource: resource)
      return if status.cached?

      yield

      status.update_attribute :cached, true
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
