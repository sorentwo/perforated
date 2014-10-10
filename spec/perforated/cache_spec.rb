require 'perforated'

describe Perforated::Cache do
  after { Perforated.cache.clear }

  Language = Struct.new(:name) do
    def to_json
      { name: name }.to_json
    end

    def cache_key
      ['Language', name]
    end
  end

  Family = Struct.new(:name, :languages) do
    def to_json
      { languages: languages }.to_json
    end

    def cache_key
      ['Family', name]
    end
  end

  describe '#to_json' do
    it 'constructs a stringified json array of underlying values' do
      ruby   = Language.new('Ruby')
      elixir = Language.new('Elixir')
      cache  = Perforated::Cache.new([ruby, elixir])

      expect(cache.to_json).to eq(%([{"name":"Ruby"},{"name":"Elixir"}]))
      expect(Perforated.cache.exist?('Language/Ruby')).to   be_truthy
      expect(Perforated.cache.exist?('Language/Elixir')).to be_truthy
    end

    it 'does not overwrite existing key values' do
      erlang = Language.new('Erlang')
      Perforated.cache.write('Language/Erlang', JSON.dump(name: 'Elixir'))

      Perforated::Cache.new([erlang]).to_json

      expect(Perforated.cache.read('Language/Erlang')).to eq(JSON.dump(name: 'Elixir'))
    end

    it 'safely returns an empty enumerable when empty' do
      cache = Perforated::Cache.new([])

      expect(cache.to_json).to eq('[]')
      expect(cache.to_json(rooted: true)).to eq('{}')
    end

    it 'applies a provided block to the object before caching' do
      ruby  = Language.new('Ruby')
      cache = Perforated::Cache.new([ruby])

      serializer = Struct.new(:lang) do
        def to_json
          { name: lang.name.upcase }.to_json
        end
      end

      results = cache.to_json do |lang|
        serializer.new(lang)
      end

      expect(results).to eq(JSON.dump([{ name: 'RUBY' }]))
    end


    it 'reconstructs rooted objects into a single merged object' do
      lisps   = Family.new('Lisp', ['scheme', 'clojure'])
      scripts = Family.new('Script', ['perl', 'ruby'])
      cache   = Perforated::Cache.new([lisps, scripts])

      expect(cache.to_json(rooted: true)).to eq(
        '{"languages":["scheme","clojure","perl","ruby"]}'
      )
    end
  end
end
