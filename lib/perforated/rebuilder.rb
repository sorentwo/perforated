require 'set'

module Perforated
  class Rebuilder
    attr_reader :parser, :strings

    def initialize(strings, parser = Perforated.json)
      @strings = strings
      @parser  = parser
    end

    def rebuild(rooted: false)
      if rooted
        parser.dump(merge(parser.load(concatenated)))
      else
        concatenated
      end
    end

    def concatenated
      "[#{strings.join(',')}]"
    end

    private

    def merge(objects)
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

      sets_to_arrays(merged)
    end

    def sets_to_arrays(merged)
      merged.each do |key, value|
        merged[key] = value.to_a
      end

      merged
    end
  end
end
