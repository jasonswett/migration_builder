require 'tty-prompt'
require_relative 'prompts/add_column'

module MigrationBuilder
  class Wizard
    TABLES_TO_EXCLUDE = %w(ar_internal_metadata schema_migrations)
    attr_reader :content, :filename

    def initialize(prompt: TTY::Prompt.new, output: $stdout)
      @prompt = prompt
      @output = output
    end

    def collect_input
      options = {
        'Add column to existing table' => {
          callback: -> {
            lines = []
            @table_name = prompt_for_table_name
            lines << "change_table :#{@table_name} do |t|"

            prompt = Prompts::AddColumn.new(@prompt)
            prompt.run

            @filename = "add_#{prompt.column_name}_to_#{@table_name}"

            lines += prompt.lines
            lines << 'end'

            @content = lines.join("\n")
          }
        },
        'Rename existing table' => {
          callback: -> {
            prompt_for_table_name
            new_table_name = @prompt.ask('New name:')

            @filename = "rename_#{@table_name}_to_#{new_table_name}"
            @content = "rename_table :#{@table_name}, :#{new_table_name}"
          }
        },
        'Create new table' => {
          callback: -> {
            lines = []
            @table_name = @prompt.ask('Table name:')
            lines << "create_table :#{@table_name} do |t|"

            prompt = Prompts::AddColumn.new(@prompt)
            prompt.run

            @filename = "create_#{@table_name}"

            lines += prompt.lines
            lines << 'end'

            @content = lines.join("\n")
          }
        },
        'Drop existing table' => {
          callback: -> {
            prompt_for_table_name
            @filename = "drop_#{@table_name}"
            @content = "drop_table :#{@table_name}"
          }
        }
      }

      action = @prompt.enum_select('What would you like to do?', options.keys)
      options[action][:callback].call
    end

    def prompt_for_table_name
      @table_name = @prompt.enum_select('Which table?', table_names)
    end

    def table_names
      ::ActiveRecord::Base.connection.tables - TABLES_TO_EXCLUDE
    end

    def start
      collect_input
      raise 'Missing table name' unless @table_name

      args = [
        @table_name,
        '--filename', @filename,
        '--content', @content
      ]

      Rails::Generators.invoke(:smart_migration, args)
    end
  end
end
