module MigrationBuilder
  class Utilities
    TABLES_TO_EXCLUDE = %w(ar_internal_metadata schema_migrations)

    def self.table_names
      ::ActiveRecord::Base.connection.tables - TABLES_TO_EXCLUDE
    end

    def self.column_names(table_name)
      ActiveRecord::Base.connection.columns(table_name).map(&:name) - ['id']
    end
  end
end
