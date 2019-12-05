require 'tty-prompt'

module MigrationBuilder
  class Prompt < TTY::Prompt
    def default_select(label, options)
      enum_select(label, options, per_page: 30)
    end
  end
end
