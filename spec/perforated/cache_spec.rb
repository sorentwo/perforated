require 'perforated'

describe Perforated::Cache do
  after { Perforated.cache.clear }

  Language = Struct.new(:name) do
    def as_json
      { name: name }
    end

    def to_json
      as_json.to_json
    end

    def cache_key
      ['Language', name]
    end
  end

  describe '#as_json' do
    it 'constructs an automatically cached serialized' do
      ruby   = Language.new('Ruby')
      elixir = Language.new('Elixir')
      array  = [ruby, elixir]
      cache  = Perforated::Cache.new(array)

      expect(cache.as_json).to eq([{ name: 'Ruby' }, { name: 'Elixir' }])

      expect(Perforated.cache.read('Language/Ruby/as-json')).to eq(ruby.as_json)
      expect(Perforated.cache.read('Language/Elixir/as-json')).to eq(elixir.as_json)
    end

    it 'does not overwrite existing key values' do
      erlang = Language.new('Erlang')
      Perforated.cache.write('Language/Erlang/as-json', { name: 'Elixir' })

      Perforated::Cache.new([erlang]).as_json

      expect(Perforated.cache.read('Language/Erlang/as-json')).to eq(name: 'Elixir')
    end
  end

  describe '#to_json' do
    it 'constructs a stringified json array of underlying values' do
      cache = Perforated::Cache.new([Language.new('Ruby'), Language.new('Elixir')])

      expect(cache.to_json).to eq(%([{"name":"Ruby"},{"name":"Elixir"}]))
      expect(Perforated.cache.exist?('Language/Ruby/to-json')).to   be_true
      expect(Perforated.cache.exist?('Language/Elixir/to-json')).to be_true
    end
  end
end
