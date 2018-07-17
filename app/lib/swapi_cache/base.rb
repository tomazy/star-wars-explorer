class SwapiCache::Base
  class << self
    protected

    def extract_id(url)
      url.split('/').last.to_i
    end

    def populate_many(json_array)
      json_array.each do |json|
        populate_one json
      end
    end

    def populate_one(json)
      raise 'Not implemented!'
    end
  end
end

