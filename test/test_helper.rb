# frozen_string_literal: true

begin
  require 'pry-byebug'
rescue LoadError
  nil
end
require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
require 'record_lifecycle'
require 'minitest/autorun'
require 'securerandom'

# Establish database connection
ActiveRecord::Base.establish_connection('adapter' => 'sqlite3', 'database' => ':memory:')
# ActiveRecord::Base.logger = Logger.new("#{File.dirname(__FILE__)}/../log/active_record.log")

if ActiveSupport.gem_version >= Gem::Version.new('4.2.0')
  ActiveSupport.test_order = :random
  ActiveRecord::Base.raise_in_transactional_callbacks = true if ActiveSupport.gem_version < Gem::Version.new('5.1.x')
end

class BaseTestCase < ActiveSupport::TestCase
  protected

  # Creates a new ActiveRecord model (and the associated table)
  def new_model(create_table = :foo, &block)
    name = create_table || :foo
    table_name = "#{name}_#{SecureRandom.hex(6)}"

    model = Class.new(ActiveRecord::Base) do
      self.table_name = table_name.to_s
      connection.create_table(table_name, force: true) { |t| t.string(:state) } if create_table

      define_method(:abort_from_callback) do
        if ActiveSupport.gem_version >= Gem::Version.new('5.0')
          throw :abort
        else
          false
        end
      end

      (
      class << self
        self
      end).class_eval do
        define_method(:name) { name.to_s.capitalize.to_s }
      end
    end
    model.class_eval(&block) if block_given?
    model.reset_column_information if create_table
    model
  end
end
