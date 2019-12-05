module MigrationBuilder
  module Subprompts
    class ChangeOrRemoveColumn
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
        selection = prompt_for_selection

        while add_another
          if selection == 'Rename column'
            @column_name = @prompt.default_select('Column to rename:', @utility_class.column_names(@table_name))
          elsif selection == 'Remove column'
            @column_name = @prompt.default_select('Column to remove:', @utility_class.column_names(@table_name))
          end

          @operations << operation(@column_name, selection)
          add_another = @prompt.yes?('Rename/remove another?')
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

      def prompt_for_selection
        @prompt.default_select(
          'Rename or remove column?',
          ['Rename column', 'Remove column']
        )
      end

      def operation(column_name, selection)
        if selection == 'Rename column'
          new_column_name = @prompt.ask('New column name:')
          @filename = "rename_#{@table_name}_#{column_name}_to_#{new_column_name}"
          "t.rename :#{column_name}, :#{new_column_name}"
        else
          @filename = "remove_#{column_name}_from_#{@table_name}"
          "t.remove :#{column_name}"
        end
      end
    end
  end
end
