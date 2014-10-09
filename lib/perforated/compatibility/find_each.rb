module Perforated
  module Compatibility
    module ArrayExtensions
      refine Array do
        def find_each(batch_size: 1000, &block)
          each_slice(batch_size) do |sub|
            sub.map(&block)
          end
        end
      end
    end
  end
end
