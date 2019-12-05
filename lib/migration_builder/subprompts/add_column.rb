module MigrationBuilder
  module Subprompts
    class AddColumn
      attr_reader :column_name, :filename

      def initialize(change_or_create:, prompt:, table_name:, utility_class:)
        @change_or_create = change_or_create

        @prompt        = prompt
        @table_name    = table_name
        @utility_class = utility_class

        @operations = []
      end

      def run
        add_another = true
        selection = 'Add column'

        while add_another
          @operations << operation(selection)
          add_another = @prompt.yes?('Add another?')
        end
      end

      def content
        operations = []
        operations << "    #{@change_or_create}_table :#{@table_name} do |t|"
        operations += @operations.map { |l| "      #{l}" }
        operations << '    end'

        @content = operations.join("\n")
      end

      private

      def operation(selection)
        column_type = @prompt.default_select('Column type:', COLUMN_TYPES)
        column_name = @prompt.ask('Column name:')
        @filename = "add_#{column_name}_to_#{@table_name}"

        nullable = @prompt.default_select('Nullable?', ['nullable', 'not nullable'])

        if nullable == 'nullable'
          "t.#{column_type} :#{column_name}"
        else
          "t.#{column_type} :#{column_name}, null: false"
        end
      end
    end
  end
end
