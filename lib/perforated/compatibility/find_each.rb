module Perforated
  module Compatibility
    def self.find_each(enumerable, batch_size: 1000, &block)
      if self.supports_find_each?(enumerable)
        enumerable.find_each(batch_size: batch_size, &block)
      else
        enumerable.each_slice(batch_size) do |array|
          array.map(&block)
        end
      end
    end

    def self.supports_find_each?(enumerable)
      enumerable.respond_to?(:find_each)
    end
  end
end

module EnumerableExtensions
  refine Array do
    def find_each(options = {}, &block)
    end
  end

  def supports_find_each?
    self.respond_to?(:find_each)
  end
end
