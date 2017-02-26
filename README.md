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

>>>>>>> 4fb1e136f2a53b9bf6ed741b04cd48b1efaeba9e
