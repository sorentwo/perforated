require 'bundler'

Bundler.setup

require 'benchmark'
require 'perforated'
require 'oj'

keys = %w[notes tags comments]
objects = (0..10_000).map do |num|
  keys = keys.rotate

  { keys.first => num }
end

strings = "[#{objects.map { |obj| JSON.dump(obj) }.join(',')}]"

N = 100

Benchmark.bmbm do |x|
  x.report('merge')         { N.times { Perforated::Rooted.merge(objects) } }
  x.report('recon')         { N.times { Perforated::Rooted.reconstruct(strings, Oj) } }
  x.report('merge-to-json') { N.times { Oj.dump(Perforated::Rooted.merge(objects)) } }
end
