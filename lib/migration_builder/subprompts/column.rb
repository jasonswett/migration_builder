module MigrationBuilder
  module Subprompts
    class Column
      attr_reader :column_name, :filename

      def initialize(change_or_create:, prompt:, table_name:, utility_class:)
        @change_or_create = change_or_create
        @allow_remove     = change_or_create == 'change'

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
            @column_name = @prompt.enum_select('Column to rename:', @utility_class.column_names(@table_name))
          elsif selection == 'Remove column'
            @column_name = @prompt.enum_select('Column to remove:', @utility_class.column_names(@table_name))
          else
            @column_name = @prompt.ask('Column name:')
          end

          @operations << operation(@column_name, selection)
          add_another = @prompt.yes?(add_another_question)
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
        if @allow_remove
          @prompt.enum_select(
            'Add, rename or remove column?',
            ['Add column', 'Rename column', 'Remove column']
          )
        else
          'Add column'
        end
      end

      def add_another_question
        @allow_remove ? 'Add/rename/remove another?' : 'Add another?'
      end

      def operation(column_name, selection)
        if selection == 'Add column'
          @filename = "add_#{column_name}_to_#{@table_name}"
          column_type = @prompt.enum_select("Type for column #{column_name}:", COLUMN_TYPES)
          nullable = @prompt.enum_select('Nullable?', ['false', 'true', 'unspecified'])

          if nullable == 'unspecified'
            "t.#{column_type} :#{column_name}"
          else
            "t.#{column_type} :#{column_name}, null: #{nullable}"
          end
        elsif selection == 'Rename column'
          new_column_name = @prompt.ask('New column name:')
          @filename = "rename_#{@table_name}_#{column_name}_to_#{new_column_name}"
          "t.rename :#{column_name}, #{new_column_name}"
        else
          @filename = "remove_#{column_name}_from_#{@table_name}"
          "t.remove :#{column_name}"
        end
      end
    end
  end
end
