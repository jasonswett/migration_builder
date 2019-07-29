module MigrationBuilder
  class Utilities
    TABLES_TO_EXCLUDE = %w(ar_internal_metadata schema_migrations)

    def self.table_names
      ::ActiveRecord::Base.connection.tables - TABLES_TO_EXCLUDE
    end
  end
end
