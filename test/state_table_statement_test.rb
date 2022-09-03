# frozen_string_literal: true

require_relative 'test_helper'

class StateTableStatementTest < BaseTestCase
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

  def test_create_state_table
    ActiveRecord::Schema.define do
      create_table :records
      create_state_table :records
    end

    assert @connection.column_exists?(:records_state_transitions, :records_id,
                                      type: :bigint, null: false, index: true)
    assert @connection.column_exists?(:records_state_transitions, :state, type: :string, null: false, index: true)
    assert @connection.column_exists?(:records_state_transitions, :former_state,
                                      type: :string, null: false, index: true)

    # assert false == @connection.column_exists?(:records_state_transitions, :arguments)
    # assert false == @connection.column_exists?(:records_state_transitions, :changes)

    assert @connection.column_exists?(:records_state_transitions, :created_at,
                                      type: :datetime, null: false,
                                      index: true)
    assert @connection.column_exists?(:records_state_transitions, :effective_at,
                                      type: :datetime, null: false,
                                      index: true)
  ensure
    begin
      @connection.drop_table(:records_state_transitions)
      @connection.drop_table(:records)
    rescue StandardError
      nil
    end
  end

  def test_add_arguments
    ActiveRecord::Schema.define do
      create_table :records
      create_state_table :records, add_arguments: true
    end

    assert @connection.column_exists?(:records_state_transitions, :arguments, type: :json)
  ensure
    begin
      @connection.drop_table(:records_state_transitions)
      @connection.drop_table(:records)
    rescue StandardError
      nil
    end
  end

  def test_add_changes
    ActiveRecord::Schema.define do
      create_table :records
      create_state_table :records, add_changes: true
    end

    assert @connection.column_exists?(:records_state_transitions, :changes, type: :json)
  ensure
    begin
      @connection.drop_table(:records_state_transitions)
      @connection.drop_table(:records)
    rescue StandardError
      nil
    end
  end

  def test_errors_table
    ActiveRecord::Schema.define do
      create_table :records
      create_state_table :records, create_error_table: true
    end

    assert @connection.column_exists?(:records_state_errors, :records_id, type: :bigint, null: false)
    assert @connection.column_exists?(:records_state_errors, :message, type: :string)
  ensure
    begin
      @connection.drop_table(:records_state_errors)
      @connection.drop_table(:records_state_transitions)
      @connection.drop_table(:records)
    rescue StandardError
      nil
    end
  end
end
