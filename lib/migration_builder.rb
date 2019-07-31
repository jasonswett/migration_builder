require 'migration_builder/railtie'
require 'migration_builder/wizard'

module MigrationBuilder
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
end
