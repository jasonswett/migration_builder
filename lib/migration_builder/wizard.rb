require_relative 'subprompts/add_column'
require_relative 'subprompts/change_or_remove_column'
require_relative 'subprompts/index'
require_relative 'prompt'
require_relative 'utilities'

module MigrationBuilder
  class Wizard
    attr_reader :content, :filename

    def initialize(utility_class: Utilities)
      @utility_class = utility_class
    end

    def collect_input(prompt: Prompt.new)
      @prompt = prompt

      commands = {
        'Add column(s) to existing table' => {
          callback: -> {
            @table_name = prompt_for_table_name

            subprompt = Subprompts::AddColumn.new(
              change_or_create: 'change',
              prompt: @prompt,
              table_name: @table_name,
              utility_class: @utility_class
            )

            subprompt.run

            @content = subprompt.content
            @filename = subprompt.filename
          }
        },
        'Rename/remove column(s) on existing table' => {
          callback: -> {
            @table_name = prompt_for_table_name

            subprompt = Subprompts::ChangeOrRemoveColumn.new(
              change_or_create: 'change',
              prompt: @prompt,
              table_name: @table_name,
              utility_class: @utility_class
            )

            subprompt.run

            @content = subprompt.content
            @filename = subprompt.filename
          }
        },
        'Add unique index on existing table' => {
          callback: -> {
            @table_name = prompt_for_table_name

            subprompt = Subprompts::Index.new(
              prompt: @prompt,
              table_name: @table_name,
              utility_class: @utility_class
            )

            subprompt.run

            @content = subprompt.content
            @filename = subprompt.filename
          }
        },
        'Rename existing table' => {
          callback: -> {
            @table_name = prompt_for_table_name
            new_table_name = @prompt.ask('New name:')

            @filename = "rename_#{@table_name}_to_#{new_table_name}"
            @content = "rename_table :#{@table_name}, :#{new_table_name}"
          }
        },
        'Create new table' => {
          callback: -> {
            @table_name = @prompt.ask('Table name:')

            subprompt = Subprompts::AddColumn.new(
              change_or_create: 'create',
              prompt: @prompt,
              table_name: @table_name,
              utility_class: @utility_class
            )

            subprompt.run

            @content = subprompt.content
            @filename = "create_#{@table_name}"
          }
        },
        'Drop existing table' => {
          callback: -> {
            @table_name = prompt_for_table_name
            @filename = "drop_#{@table_name}"
            @content = "    drop_table :#{@table_name}"
          }
        }
      }

      if table_names.any?
        options = commands.keys
      else
        options = ['Create new table']
      end

      action = @prompt.default_select('What would you like to do?', options)
      commands[action][:callback].call if action
    end

    def prompt_for_table_name
      @prompt.default_select('Which table?', table_names)
    end

    def table_names
      @utility_class.table_names.sort
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
