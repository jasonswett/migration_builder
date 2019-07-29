module MigrationBuilder
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/migration_builder_tasks.rake'
    end
  end
end
