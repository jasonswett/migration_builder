module MigrationBuilder
  module Subprompts
    class AddColumn
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

      attr_reader :column_name, :lines, :table_name

      def initialize(prompt)
        @prompt = prompt
        @lines = []
      end

      def run
        add_another = nil

        while add_another != 'n'
          @column_name = @prompt.ask('Column name:')
          @column_type = @prompt.enum_select("Column type for #{column_name}:", COLUMN_TYPES)
          @lines << "t.#{@column_type} :#{@column_name}"

          add_another = @prompt.ask('Add another?')
        end
      end
    end
  end
end
