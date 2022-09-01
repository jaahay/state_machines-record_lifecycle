# frozen_string_literal: true

# no-doc
# :no-doc:
module ActiveRecord
  module ConnectionAdapters
    ## plugs into class `ActiveRecord::ConnectionAdapters::AbstractAdapter`
    ## this is where `create_table` is implemented
    ## so, this would be analogous to `create_state_machine`
    ## this is where you find `TableDefinition.new` (inside of schema_statements.rb)
    class AbstractAdapter
      include RecordLifecycle::StateTableStatement
    end
  end
end
