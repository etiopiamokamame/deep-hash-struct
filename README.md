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

```ruby
wrapper         = Deep::Hash::Struct::Wrapper.new
wrapper.a       = 1
wrapper.b.a     = 2
wrapper[:c][:a] = 3
wrapper[:c].b   = 4
wrapper.to_h # => {:a=>1, :b=>{:a=>2}, :c=>{:a=>3, :b=>4}}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/etiopiamokamame/deep-hash-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
