module MigrationBuilder
  module Prompts
    class AddColumn
      TABLES_TO_EXCLUDE = %w(ar_internal_metadata schema_migrations)
      attr_reader :filename, :content, :table_name

      def initialize(prompt)
        @prompt = prompt
      end

      def run
        @table_name = prompt_for_table_name
        column_name = @prompt.ask('New column name:')

        types = %w(
              string
              text
              integer
              bigint
              float
              decimal
              numeric
              datetime
              time
              date
              binary
              boolean
              primary_key
        )

        column_type = @prompt.enum_select('Type:', types)

        @filename = "add_#{column_name}_to_#{@table_name}"
        @content = "add_column :#{@table_name}, :#{column_name}, :#{column_type}"
      end

      def prompt_for_table_name
        @prompt.enum_select('Which table?', table_names)
      end

      def table_names
        ::ActiveRecord::Base.connection.tables - TABLES_TO_EXCLUDE
      end
    end
  end
end
