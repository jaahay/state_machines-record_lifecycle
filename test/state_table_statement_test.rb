# frozen_string_literal: true

require_relative 'test_helper'

class TableDefinitionTest < BaseTestCase
  setup do
    @original_verbose = ActiveRecord::Migration.verbose
    ActiveRecord::Migration.verbose = false
    @connection = ActiveRecord::Base.connection
    @schema_migration = @connection.schema_migration
    @schema_migration.drop_table
    # @internal_metadata = @connection.internal_metadata
  end

  teardown do
    begin
      @schema_migration.delete_all
    rescue StandardError
      nil
    end
    ActiveRecord::Migration.verbose = @original_verbose
  end

  def test_state_machine
    ActiveRecord::Schema.define do
      create_table :records do |t|
        t.string :name
        t.string :external_id
      end

      create_state_table :records
    end

    assert @connection.column_exists?(:records, :name)
    assert @connection.column_exists?(:records, :external_id)
    assert @connection.column_exists?(:records_state_transitions, :records_id)
    assert @connection.column_exists?(:records_state_transitions, :created_at)
  end
end
