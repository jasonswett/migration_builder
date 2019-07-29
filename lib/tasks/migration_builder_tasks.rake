require_relative '../migration_builder/wizard'

namespace :mb do
  task start: :environment do
    MigrationBuilder::Wizard.new.start
  end
end
