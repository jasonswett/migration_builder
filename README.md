# Migration Builder
Migration Builder is an interactive command-line tool that builds Rails migrations. The goal is for Migration Builder to be able to generate 95% of common migration types without having to google the Rails migration syntax.

Note: Migration Builder is currently in an EXTREMELY early stage of development, so set your expectations accordingly.

## Usage
To start the Migration Builder prompt, run:

```
$ rails mb:start
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

## Capabilities

Migration Builder features currently include:

- Adding/removing column(s) on existing tables
- Renaming existing tables
- Creating new tables
- Dropping existing tables

## Feedback and contributing
This is my first swing at OSS and I have no idea how it works. If you find a bug (which is really easy at this stage!) or have a feature idea (also easy since Migration Builder does almost nothing so far!), feel free to open an issue on this repo.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
