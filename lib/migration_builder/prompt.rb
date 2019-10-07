require 'tty-prompt'

module MigrationBuilder
  class Prompt < TTY::Prompt
    def default_select(label, options)
      select(label, options, per_page: 50)
    end
  end
end
