module MigrationBuilder
  module Subprompts
    class Index
      attr_reader :filename, :content

      def initialize(prompt:, table_name:, utility_class:)
        @prompt        = prompt
        @table_name    = table_name
        @utility_class = utility_class

        @operations = []
      end

      def run
        column_names = []
        add_another = true

        while add_another
          column_names << @prompt.default_select(
            'Column:',
            @utility_class.column_names(@table_name)
          )

          add_another = @prompt.yes?('Add another column to the index?')
        end

        @filename = "add_unique_index_on_#{@table_name}_#{column_names.join('_')}"
        @content = "    add_index :#{@table_name}, #{column_names_as_array(column_names)}, unique: true"
      end

      private

      def column_names_as_array(column_names)
        '[' + column_names.map { |cn| ":#{cn}" }.join(', ') + ']'
      end
    end
  end
end
