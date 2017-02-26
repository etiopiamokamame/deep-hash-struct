<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> a04afc2... lf => crlf
=======
>>>>>>> add merge, fetch and initialize
=======
>>>>>>> add merge, fetch and initialize
=======
=======
>>>>>>> a04afc2... lf => crlf
>>>>>>> lf => crlf
# Deep::Hash::Struct

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/deep/hash/struct`. To experiment with that code, run `bin/console` for an interactive prompt.

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

wrapper         = Deep::Hash::Struct::Wrapper.new
wrapper.a       = 1
wrapper.b.a     = 2
wrapper[:c][:a] = 3
wrapper[:c].b   = 4
wrapper.to_h        # => => {:a=>1, :b=>{:a=>2}, :c=>{:a=>3, :b=>4}}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/etiopiamokamame/deep-hash-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> lf => crlf

=======
# Deep::Hash::Struct

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/deep/hash/struct`. To experiment with that code, run `bin/console` for an interactive prompt.
<<<<<<< HEAD
=======
# Deep::Hash::Struct

Struct copes with the operation that is Deep.
Because the data maintenance of many hierarchies became possible, I can treat it like Hash.
>>>>>>> 3748c61... update version to 0.1.2
=======
>>>>>>> add merge, fetch and initialize

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep-hash-struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deep-hash-struct

<<<<<<< HEAD
## Wrapper Class Usage
The basic usage is the same as Hash Class.

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
### Basic
>>>>>>> 7555320... version 0.1.2 README
```ruby
>>>>>>> 3748c61... update version to 0.1.2
=======
## Usage

>>>>>>> add merge, fetch and initialize
wrapper         = Deep::Hash::Struct::Wrapper.new
wrapper.a       = 1
wrapper.b.a     = 2
wrapper[:c][:a] = 3
wrapper[:c].b   = 4
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> add merge, fetch and initialize
wrapper.to_h        # => => {:a=>1, :b=>{:a=>2}, :c=>{:a=>3, :b=>4}}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
<<<<<<< HEAD
=======
wrapper.to_h # => {:a=>1, :b=>{:a=>2}, :c=>{:a=>3, :b=>4}}
```
>>>>>>> 3748c61... update version to 0.1.2

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
wrapper.c.b = ""
wrapper.d.a = nil

wrapper.keys           # => [:a, :b, :c, :d]
wrapper.c.keys         # => [:a, :b]
wrapper.compact.keys   # => [:a, :c, :d]
wrapper.compact.c.keys # => [:a, :b]
wrapper.keys           # => [:a, :b, :c, :d]
wrapper.c.keys         # => [:a, :b]
```

### #compact!
bang compact method

### #deep_compact
```ruby
wrapper.a   = 1
wrapper.b   = nil
wrapper.c.a = 2
wrapper.c.b = ""
wrapper.d.a = nil

wrapper.keys                # => [:a, :b, :c, :d]
wrapper.c.keys              # => [:a, :b]
wrapper.deep_compact.keys   # => [:a, :c]
wrapper.deep_compact.c.keys # => [:a, :b]
wrapper.keys                # => [:a, :b, :c, :d]
wrapper.c.keys              # => [:a, :b]
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

### #max_stages
```ruby
wrapper.a     = 1
wrapper.b.a   = 2
wrapper.b.b   = 3
wrapper.c.a.b = 4
wrapper.c.a.c = 5
wrapper.c.a.d = 6

wrapper.max_stages   # => 3
wrapper.b.max_stages # => 1
wrapper.c.max_stages # => 2
```

### #min_stages
```ruby
wrapper.a     = 1
wrapper.b.a   = 2
wrapper.b.b   = 3
wrapper.c.a.b = 4
wrapper.c.a.c = 5
wrapper.c.a.d = 6

wrapper.min_stages   # => 1
wrapper.b.min_stages # => 1
wrapper.c.min_stages # => 2
```

## Dashboard Class Usage
It is used like a two-dimensional array representing a table.

### Add matrix table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table(matrix: true, side_header: "sh") do |t|
  t.add_header do |h|
    h.a   = "h1"
    h[:b] = "h2"
    h.add :c, "h3"
  end

  t.add_side do |s|
    s.a   = "s1"
    s[:b] = "s2"
    s.add :c, "s3"
  end

  t.add_body do |row|
    row.a.a     = 11
    row.a[:b]   = 12
    row[:a][:c] = 13
    row[:b].a   = 14
    row.b.add :b, 15
    row.b.c     = 16
    row.c.a     = 17
    row.c.b     = 18
    row.c.c     = 19
  end
end

dashboard.tables # => [#<Table matrix=true>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header? || row.side?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>   <tr>
# =>     <th>sh</th>
# =>     <th>h1</th>
# =>     <th>h2</th>
# =>     <th>h3</th>
# =>   </tr>
# =>   <tr>
# =>     <th>s1</th>
# =>     <td>11</td>
# =>     <td>14</td>
# =>     <td>17</td>
# =>   </tr>
# =>   <tr>
# =>     <th>s2</th>
# =>     <td>12</td>
# =>     <td>15</td>
# =>     <td>18</td>
# =>   </tr>
# =>   <tr>
# =>     <th>s3</th>
# =>     <td>13</td>
# =>     <td>16</td>
# =>     <td>19</td>
# =>   </tr>
# => </table>
```

### Add segment table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table do |t|
  t.add_header do |h|
    h.a   = "h1"
    h[:b] = "h2"
    h.add :c, "h3"
  end

  t.add_body do |row|
    row.a = 11
    row.b = 12
    row.c = 13
  end

  t.add_body do |row|
    row.c = 16
    row.b = 15
    row.a = 14
  end

  t.add_body do |row|
    row.c = 19
    row.a = 17
    row.b = 18
  end
end

dashboard.tables # => [#<Table matrix=false>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>   <tr>
# =>     <th>h1</th>
# =>     <th>h2</th>
# =>     <th>h3</th>
# =>   </tr>
# =>   <tr>
# =>     <td>11</td>
# =>     <td>12</td>
# =>     <td>13</td>
# =>   </tr>
# =>   <tr>
# =>     <td>14</td>
# =>     <td>15</td>
# =>     <td>16</td>
# =>   </tr>
# =>   <tr>
# =>     <td>17</td>
# =>     <td>18</td>
# =>     <td>19</td>
# =>   </tr>
# => </table>
```

### Unset value to matrix table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table(matrix: true) do |t|
  t.add_header do |h|
    h.a   = "h1"
    h[:b] = "h2"
    h.add :c, "h3"
  end

  t.add_side do |s|
    s.a   = "s1"
    s[:b] = "s2"
    s.add :c, "s3"
  end

  t.add_body do |row|
    row.a.b = 2
    row.a.c = 3
    row.b.a = 4
    row.b.c = 6
    row.c.a = 7
    row.c.b = 8
  end
end

dashboard.tables # => [#<Table matrix=true>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header? || row.side?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>  <tr>
# =>    <th></th>
# =>    <th>h1</th>
# =>    <th>h2</th>
# =>    <th>h3</th>
# =>  </tr>
# =>  <tr>
# =>    <th>s1</th>
# =>    <td></td>
# =>    <td>4</td>
# =>    <td>7</td>
# =>  </tr>
# =>  <tr>
# =>    <th>s2</th>
# =>    <td>2</td>
# =>    <td></td>
# =>    <td>8</td>
# =>  </tr>
# =>  <tr>
# =>    <th>s3</th>
# =>    <td>3</td>
# =>    <td>6</td>
# =>    <td></td>
# =>  </tr>
# =></table>
```
### Unset value to segment table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table do |t|
  t.add_header do |h|
    h.a = "h1"
    h.b = "h2"
    h.c = "h3"
  end

  t.add_body do |row|
    row.b = 2
    row.c = 3
  end

  t.add_body do |row|
    row.a = 4
    row.c = 6
  end

  t.add_body do |row|
    row.a = 7
    row.b = 8
  end
end

dashboard.tables # => [#<Table matrix=false>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>   <tr>
# =>     <th>h1</th>
# =>     <th>h2</th>
# =>     <th>h3</th>
# =>   </tr>
# =>   <tr>
# =>     <td></td>
# =>     <td>2</td>
# =>     <td>3</td>
# =>   </tr>
# =>   <tr>
# =>     <td>4</td>
# =>     <td></td>
# =>     <td>6</td>
# =>   </tr>
# =>   <tr>
# =>     <td>7</td>
# =>     <td>8</td>
# =>     <td></td>
# =>   </tr>
# => </table>
```

### Default to matrix table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table(matrix: true, default: 0) do |t|
  t.add_header do |h|
    h.a = "h1"
    h.b = "h2"
    h.c = "h3"
  end

  t.add_side do |s|
    s.a = "s1"
    s.b = "s2"
    s.c = "s3"
  end

  t.add_body do |row|
    row.a.b = 2
    row.a.c = 3
    row.b.a = 4
    row.b.c = 6
    row.c.a = 7
    row.c.b = 8
  end
end

dashboard.tables # => [#<Table matrix=true>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header? || row.side?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>   <tr>
# =>     <th></th>
# =>     <th>h1</th>
# =>     <th>h2</th>
# =>     <th>h3</th>
# =>   </tr>
# =>   <tr>
# =>     <th>s1</th>
# =>     <td>0</td>
# =>     <td>4</td>
# =>     <td>7</td>
# =>   </tr>
# =>   <tr>
# =>     <th>s2</th>
# =>     <td>2</td>
# =>     <td>0</td>
# =>     <td>8</td>
# =>   </tr>
# =>   <tr>
# =>     <th>s3</th>
# =>     <td>3</td>
# =>     <td>6</td>
# =>     <td>0</td>
# =>   </tr>
# => </table>
```

### Default to segment table
```ruby
dashboard = Deep::Hash::Struct::Dashboard.new
dashboard.add_table(default: 0) do |t|
  t.add_header do |h|
    h.a = "h1"
    h.b = "h2"
    h.c = "h3"
  end

  t.add_body do |row|
    row.b = 2
    row.c = 3
  end

  t.add_body do |row|
    row.a = 4
    row.c = 6
  end

  t.add_body do |row|
    row.a = 7
    row.b = 8
  end
end

dashboard.tables # => [#<Table matrix=false>]

table = "<table>\n"
dashboard.tables[0].each do |rows|
  table << "  <tr>\n"
  rows.each do |row|
    if row.header?
      table << "    <th>#{row.name}</th>\n"
    else
      table << "    <td>#{row.value}</td>\n"
    end
  end
  table << "  </tr>\n"
end
table << "</table>\n"

puts table
# => <table>
# =>   <tr>
# =>     <th>h1</th>
# =>     <th>h2</th>
# =>     <th>h3</th>
# =>   </tr>
# =>   <tr>
# =>     <td>0</td>
# =>     <td>2</td>
# =>     <td>3</td>
# =>   </tr>
# =>   <tr>
# =>     <td>4</td>
# =>     <td>0</td>
# =>     <td>6</td>
# =>   </tr>
# =>   <tr>
# =>     <td>7</td>
# =>     <td>8</td>
# =>     <td>0</td>
# =>   </tr>
# => </table>
```
=======
>>>>>>> add merge, fetch and initialize

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/etiopiamokamame/deep-hash-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
<<<<<<< HEAD
<<<<<<< HEAD

>>>>>>> 4fb1e13... add merge, fetch and initialize
=======
>>>>>>> a04afc2... lf => crlf
=======
>>>>>>> 3748c61... update version to 0.1.2
=======

>>>>>>> add merge, fetch and initialize
=======

>>>>>>> 4fb1e13... add merge, fetch and initialize
<<<<<<< HEAD
>>>>>>> add merge, fetch and initialize
=======
=======
>>>>>>> a04afc2... lf => crlf
>>>>>>> lf => crlf
