[![CircleCI](https://circleci.com/gh/hortoncd/registered_domains.svg?style=svg)](https://circleci.com/gh/hortoncd/registered_domains)

# RegisteredDomains

Return a list of domains registered at a registrar.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'registered_domains'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install registered_domains

## Usage
Currently this works for Name.com and Namecheap

Name.com
```
nc = NameCom::Domains.new('user', 'apikey')
nc.domains
> ['fakedomain.com']
```

Namecheap
```
nc = Namecheap::Domains.new('user', 'apikey', 'apiuser')
nc.domains
> ['fakedomain.com']
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hortoncd/registered_domains.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
