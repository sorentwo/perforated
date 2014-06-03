require 'set'

module Perforated
  module Rooted
    def self.merge(objects)
      merged = objects.each_with_object({}) do |object, memo|
        object.each do |key, value|
          memo[key] ||= Set.new

          if value.is_a?(Array)
            memo[key].merge(value)
          else
            memo[key].add(value)
          end
        end
      end

      sets_to_hashes(merged)
    end

    def self.reconstruct(objects, parser = JSON)
      parser.dump(merge(parser.load(objects)))
    end

    def self.sets_to_hashes(object)
      object.each do |key, value|
        object[key] = value.to_a
      end

      object
    end
  end
end
