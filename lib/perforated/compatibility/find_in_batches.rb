module Perforated
  module Compatibility
    module FindInBatches
      refine Array do
        def find_in_batches(batch_size: 1000, &block)
          each_slice(batch_size, &block)
        end
      end
    end
  end
end
