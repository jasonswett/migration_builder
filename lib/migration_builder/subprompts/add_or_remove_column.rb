module MigrationBuilder
  module Subprompts
    class AddOrRemoveColumn
      COLUMN_TYPES = %w(
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

      attr_reader :column_name, :lines

      def initialize(prompt, allow_remove: true)
        @prompt = prompt
        @lines = []
        @allow_remove = allow_remove
      end

      def run
        add_another = nil

        while add_another != 'n'
          puts "allow_remove is #{@allow_remove}"
          add_or_remove = @allow_remove ? @prompt.enum_select('Add or remove?', ['Add', 'Remove']) : 'Add'

          @column_name = @prompt.ask('Column name:')

          if add_or_remove == 'Add'
            @column_type = @prompt.enum_select("Column type for #{column_name}:", COLUMN_TYPES)
            @lines << "t.#{@column_type} :#{@column_name}"
          else
            @lines << "t.remove :#{@column_name}"
          end

          question = @allow_remove ? 'Add/remove another?' : 'Add another?'
          add_another = @prompt.ask(question)
        end
      end
    end
  end
end
