require 'rails/generators/active_record'

class SmartMigrationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  include Rails::Generators::Migration
  class_option :filename, type: :string
  class_option :content, type: :string

	def self.next_migration_number(dirname)
		ActiveRecord::Generators::Base.next_migration_number(dirname)
	end

  def create_migration_file
    migration_template('migration.rb.tt', filename)
  end

  def content
    options['content']
  end

  def filename
    "db/migrate/#{basename}.rb"
  end

  def basename
    if options['filename'].present?
      options['filename']
    else
      "alter_#{table_name}"
    end
  end
end
