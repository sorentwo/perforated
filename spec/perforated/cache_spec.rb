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

  Family = Struct.new(:name, :languages) do
    def as_json
      { languages: languages }
    end

    def to_json
      as_json.to_json
    end

    def cache_key
      ['Family', name]
    end
  end

  describe '#as_json' do
    it 'constructs automatically cached serialized output' do
      ruby   = Language.new('Ruby')
      elixir = Language.new('Elixir')
      cache  = Perforated::Cache.new([ruby, elixir])

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

    it 'merges objects comprised of rooted arrays' do
      lisps   = Family.new('Lisp', ['scheme', 'clojure'])
      scripts = Family.new('Script', ['perl', 'ruby'])
      cache   = Perforated::Cache.new([lisps, scripts])

      expect(cache.as_json(rooted: true)).to eq(
        languages: %w[scheme clojure perl ruby]
      )
    end

    it 'safely returns an empty enumerable when empty' do
      cache = Perforated::Cache.new([])

      expect(cache.as_json).to eq([])
      expect(cache.as_json(rooted: true)).to eq({})
    end

    it 'applies a provided block to the object before caching' do
      ruby  = Language.new('Ruby')
      cache = Perforated::Cache.new([ruby])

      serializer = Struct.new(:lang) do
        def as_json
          { name: lang.name.upcase }
        end
      end

      results = cache.as_json do |lang|
        serializer.new(lang)
      end

      expect(results).to eq([{ name: 'RUBY' }])
    end
  end

  describe '#to_json' do
    it 'constructs a stringified json array of underlying values' do
      cache = Perforated::Cache.new([Language.new('Ruby'), Language.new('Elixir')])

      expect(cache.to_json).to eq(%([{"name":"Ruby"},{"name":"Elixir"}]))
      expect(Perforated.cache.exist?('Language/Ruby/to-json')).to   be_truthy
      expect(Perforated.cache.exist?('Language/Elixir/to-json')).to be_truthy
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
