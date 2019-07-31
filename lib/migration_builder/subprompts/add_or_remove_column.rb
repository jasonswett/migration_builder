module MigrationBuilder
  module Subprompts
    class AddOrRemoveColumn
      attr_reader :column_name, :lines

      def initialize(change_or_create, prompt, table_name)
        @prompt           = prompt
        @table_name       = table_name
        @change_or_create = change_or_create
        @allow_remove     = change_or_create == 'change'
        @lines            = []
      end

      def run
        add_another = true

        while add_another
          add_or_remove = @allow_remove ? @prompt.enum_select('Add column or remove column?', ['Add column', 'Remove column']) : 'Add column'
          @column_name = @prompt.ask('Column name:')
          @lines << line(@column_name, add_or_remove)
          add_another = @prompt.yes?(add_another_question)
        end
      end

      def content
        lines = []
        lines << "    #{@change_or_create}_table :#{@table_name} do |t|"
        lines += @lines.map { |l| "      #{l}" }
        lines << '    end'

        @content = lines.join("\n")
      end

      private

      def add_another_question
        @allow_remove ? 'Add/remove another?' : 'Add another?'
      end

      def line(column_name, add_or_remove)
        if add_or_remove == 'Add column'
          column_type = @prompt.enum_select("Type for column #{column_name}:", COLUMN_TYPES)

          nullable = @prompt.enum_select('Nullable?', ['false', 'true', 'unspecified'])
          if nullable == 'unspecified'
            "t.#{column_type} :#{column_name}"
          else
            "t.#{column_type} :#{column_name}, null: #{nullable}"
          end
        else
          "t.remove :#{column_name}"
        end
      end
    end
  end
end
