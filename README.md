# Deep::Hash::Struct

Struct copes with the operation that is Deep.
Because the data maintenance of many hierarchies became possible, I can treat it like Hash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep-hash-struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deep-hash-struct

## Usage
The basic usage is the same as Hash Class.

### Basic
```ruby
wrapper         = Deep::Hash::Struct::Wrapper.new
wrapper.a       = 1
wrapper.b.a     = 2
wrapper[:c][:a] = 3
wrapper[:c].b   = 4
wrapper.to_h # => {:a=>1, :b=>{:a=>2}, :c=>{:a=>3, :b=>4}}
```

### Block
```ruby
wrapper.a do
  1 + 1
end
wrapper.a # => 2

wrapper.b do
  { c: 3 }
end
wrapper.b.c # => 3
```

### #dig
```ruby
wrapper.a.b = { c: 1, d: [1, 2, [3, 4, 5]] }
wrapper.dig(:a, :b, :c)       # => 1
wrapper.dig(:a, :b, :d, 2, 0) # => 3
wrapper.dig(:a, :c).blank?    # => true
```

### #merge
#### Deep::Hash::Struct::Wrapper Class
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.c.b = 4
wrapper.c.c = 5

other       = wrapper.class.new
other.a     = 6
other.b     = 7
other.c.a   = 8

wrapper.merge(other).to_h # => {:a=>6, :b=>7, :c=>{:a=>8}}
```

#### Hash Class
```ruby
wrapper.a     = 1
wrapper.b     = 2
wrapper.c.a   = 3
wrapper.c.b   = 4
wrapper.c.c   = 5

other         = {}
other[:a]     = 6
other[:b]     = 7
other[:c]     = {}
other[:c][:a] = 8

wrapper.merge(other).to_h #=> {:a=>6, :b=>7, :c=>{:a=>8}}
```

### #merge! #update
bang merge method

### #deep_merge
#### Deep::Hash::Struct::Wrapper Class
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.c.b = 4
wrapper.c.c = 5

other       = wrapper.class.new
other.a     = 6
other.b     = 7
other.c.a   = 8

wrapper.deep_merge(other).to_h # => {:a=>6, :b=>7, :c=>{:a=>8, :b=>4, :c=>5}}
```

#### Hash Class
```ruby
wrapper.a     = 1
wrapper.b     = 2
wrapper.c.a   = 3
wrapper.c.b   = 4
wrapper.c.c   = 5

other         = {}
other[:a]     = 6
other[:b]     = 7
other[:c]     = {}
other[:c][:a] = 8

wrapper.deep_merge(other).to_h # => {:a=>6, :b=>7, :c=>{:a=>8, :b=>4, :c=>5}}
```

### #deep_merge!
bang deep_merge method

### #reverse_merge
#### Deep::Hash::Struct::Wrapper Class
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.c.b = 4
wrapper.c.c = 5

other       = wrapper.class.new
other.a     = 6
other.b     = 7
other.c.a   = 8
other.d.a   = 9

wrapper.reverse_merge(other).to_h # => {:a=>1, :b=>2, :c=>{:a=>3, :b=>4, :c=>5}, :d=>{:a=>9}}
```

#### Hash Class
```ruby
wrapper.a     = 1
wrapper.b     = 2
wrapper.c.a   = 3
wrapper.c.b   = 4
wrapper.c.c   = 5

other         = {}
other[:a]     = 6
other[:b]     = 7
other[:c]     = {}
other[:c][:a] = 8
other[:d]     = {}
other[:d][:a] = 9

wrapper.reverse_merge(other).to_h # => {:a=>1, :b=>2, :c=>{:a=>3, :b=>4, :c=>5}, :d=>{:a=>9}}
```

### #reverse_merge!
bang reverse_merge method

### #reverse_deep_merge
#### Deep::Hash::Struct::Wrapper Class
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.c.b = 4
wrapper.c.c = 5

other       = wrapper.class.new
other.a     = 6
other.b     = 7
other.c.a   = 8
other.c.d   = 9

wrapper.reverse_deep_merge(other).to_h # => {:a=>1, :b=>2, :c=>{:a=>3, :b=>4, :c=>5, :d=>9}}
```

#### Hash Class
```ruby
wrapper.a     = 1
wrapper.b     = 2
wrapper.c.a   = 3
wrapper.c.b   = 4
wrapper.c.c   = 5

other         = {}
other[:a]     = 6
other[:b]     = 7
other[:c]     = {}
other[:c][:a] = 8
other[:c][:d] = 9

wrapper.reverse_deep_merge(other).to_h # => {:a=>1, :b=>2, :c=>{:a=>3, :b=>4, :c=>5, :d=>9}}
```

### #reverse_deep_merge!
bang reverse_deep_merge method

### #fetch
```ruby
wrapper.a = 1
wrapper.fetch(:a, :not_found)              # => 1
wrapper.fetch(:a) { |k| "#{k} not found" } # => 1
wrapper.fetch(:b)                          # => nil
wrapper.fetch(:b, :not_found)              # => :not_found
wrapper.fetch(:b) { |k| "#{k} not found" } # => "b not found"
```

### #default
```ruby
wrapper.a.default = 0
wrapper.b.default = []
wrapper.a.a # => 0
wrapper.b.a # => []
```

### #map_key
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.map_key { |k| [k] } # => [[:a], [:b], [:c]]
```

### #map_value
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.map_value { |k| [k] } # => [[1], [2], [3]]
```

### #fetch_values
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.fetch_values(:a, :b)                  # => [1, 2]
wrapper.fetch_values(:a, :c)                  # => KeyError: key not found: :c
wrapper.fetch_values(:a, :c) { |k| k.upcase } # => [1, :C]
```

### #values_at
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.values_at(:a, :b, :d) # => [1, 2, nil]
```

### #invert
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.invert # => {1=>:a, 2=>:b, 3=>:c}
```

### #delete
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.delete(:a) # => 1
wrapper.keys       # => [:b, :c]
```

### #delete_if
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.delete_if{ |k, v| k == :a || v == 2 }.to_h # => {:c=>3}
wrapper.keys                                       # => [:c]
```

### #reject
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.reject { |k, v| v > 2 }.to_h # => {:a=>1, :b=>2}
```

### #reject!
bang reject method

### #clear
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.clear
wrapper.to_h # => {}
```

### #flatten
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.c.b = 4
wrapper.c.c = 5
wrapper.flatten # => [:a, 1, :b, 2, :c, {:a=>3, :b=>4, :c=>5}]
```

### #has_key? #include?
```ruby
wrapper.a = 1
wrapper.has_key?(:a) # => true
wrapper.has_key?(:b) # => false
```

### #has_keys?
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.has_keys?(:a)     # => true
wrapper.has_keys?(:c, :a) # => true
wrapper.has_keys?(:d)     # => false
wrapper.has_keys?(:c, :b) # => false
wrapper.has_keys?(:d, :a) # => false
```

### #exclude?
```ruby
wrapper.a = 1
wrapper.exclude?(:a) # => false
wrapper.exclude?(:d) # => true
```

### #sort
```ruby
wrapper.c = 1
wrapper.b = 2
wrapper.a = 3
wrapper.sort # => [[:a, 3], [:b, 2], [:c, 1]]
```

### #shift
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3
wrapper.shift # => [:a, 1]
wrapper.to_h  # => {:b=>2, :c=>3}
```

### #compact
```ruby
wrapper.a   = 1
wrapper.b   = nil
wrapper.c.a = 2
wrapper.c.b
wrapper.c.c = ""

wrapper.keys           # => [:a, :b, :c]
wrapper.c.keys         # => [:a, :b, :c]
wrapper.compact.keys   # => [:a, :c]
wrapper.compact.c.keys # => [:a, :b, :c]
wrapper.keys           # => [:a, :b, :c]
wrapper.c.keys         # => [:a, :b, :c]
```

### #compact!
bang compact method

### #deep_compact
```ruby
wrapper.a   = 1
wrapper.b   = nil
wrapper.c.a = 2
wrapper.c.b
wrapper.c.c = ""

wrapper.keys                # => [:a, :b, :c]
wrapper.c.keys              # => [:a, :b, :c]
wrapper.deep_compact.keys   # => [:a, :c]
wrapper.deep_compact.c.keys # => [:a, :c]
wrapper.keys                # => [:a, :b, :c]
wrapper.c.keys              # => [:a, :b, :c]
```

### #deep_compact!
bang deep_compact method

### #slice
```ruby
wrapper.a = 1
wrapper.b = 2
wrapper.c = 3

wrapper.slice(:a, :b).to_h # => {:a=>1, :b=>2}
wrapper.slice(:b, :c).to_h # => {:b=>2, :c=>3}
wrapper.slice(:c, :d).to_h # => {:c=>3}
wrapper.to_h               # => {:a=>1, :b=>2, :c=>3}
```

### #slice!
bang slice method

### #to_hash #to_h
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3

wrapper.to_hash # => {:a=>1, :b=>2, :c=>{:a=>3}}
```

### #to_json
```ruby
wrapper.a   = 1
wrapper.b   = 2
wrapper.c.a = 3
wrapper.to_json # => "{\"a\":1,\"b\":2,\"c\":{\"a\":3}}"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/etiopiamokamame/deep-hash-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
