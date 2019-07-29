# Migration Builder
Migration Builder is an interactive command-line tool that builds Rails migrations. The goal is for Migration Builder to be able to generate 95% of the migration types I want without me having to google the Rails migration syntax.

## Usage
To start the Migration Builder prompt, run:

```
$ rails db:start
```

## Installation
Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'migration_builder', git: 'https://github.com/jasonswett/migration_builder'
end
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install migration_builder
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
