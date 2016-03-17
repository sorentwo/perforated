RSpec.describe Perforated::Rebuilder do
  describe '#rebuild' do
    it 'merges stringified json' do
      string_a = JSON.dump(families: { name: 'lang' }, languages: [{ name: 'scheme' }])
      string_b = JSON.dump(families: { name: 'lang' }, languages: [{ name: 'clojure' }])

      rooted = Perforated::Rebuilder.new([string_a, string_b], JSON)

      expect(rooted.rebuild(rooted: true)).to eq(
        '{"families":[{"name":"lang"}],"languages":[{"name":"scheme"},{"name":"clojure"}]}'
      )
    end
  end
end
