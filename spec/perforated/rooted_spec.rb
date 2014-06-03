require 'perforated'

describe Perforated::Rooted do
  describe '.merge' do
    it 'merges all nested objects' do
      obj_a = { languages: [{ name: 'scheme' }] }
      obj_b = { languages: [{ name: 'clojure' }] }

      expect(Perforated::Rooted.merge([obj_a, obj_b])).to eq(
        languages: [{ name: 'scheme' }, { name: 'clojure' }]
      )
    end
  end

  describe '.reconstruct' do
    it 'merges stringified json' do
      obj_a  = JSON.dump({ languages: [{ name: 'scheme' }] })
      obj_b  = JSON.dump({ languages: [{ name: 'clojure' }] })
      concat = "[#{obj_a},#{obj_b}]"

      expect(Perforated::Rooted.reconstruct(concat)).to eq(
        '{"languages":[{"name":"scheme"},{"name":"clojure"}]}'
      )
    end
  end
end
