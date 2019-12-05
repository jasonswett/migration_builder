$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "migration_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "migration_builder"
  spec.version     = MigrationBuilder::VERSION
  spec.authors     = ["Jason Swett"]
  spec.email       = ["jason@codewithjason.com.com"]
  spec.homepage    = "https://www.codewithjason.com/migration-builder-never-google-rails-migration-syntax/"
  spec.summary     = "Interactive command-line tool for building Rails migrations."
  spec.description = "Interactive command-line tool for building Rails migrations."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.0"
  spec.add_dependency "tty-prompt"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "pry"
end
