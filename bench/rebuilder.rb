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

strings   = objects.map { |obj| JSON.dump(obj) }
rebuilder = Perforated::Rebuilder.new(strings, Oj)

N = 100

Benchmark.bmbm do |x|
  x.report('rebuild') { N.times { rebuilder.rebuild(rooted: true) } }
end
