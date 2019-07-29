module MigrationBuilder
  module Prompts
    class AddColumn
      attr_reader :column_name, :lines, :table_name

      def initialize(prompt)
        @prompt = prompt
        @lines = []
      end

      def run
        @column_name = @prompt.ask('Column name:')

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

        @column_type = @prompt.enum_select("Column type for #{column_name}:", types)
        @lines << "t.#{@column_type} :#{@column_name}"
      end
    end
  end
end
