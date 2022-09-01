# frozen_string_literal: true

# :no-doc:
module RecordLifecycle
  module StateTableStatement
    ## persist per-record transitions
    ## for table "students" -> "students_state_transitions"
    ## for table "students" machine "enrollments" -> "students_enrollment_transitions"

    def create_state_table(record_table_name, machine_name: 'state', **options)
      table_name = "#{record_table_name}_#{machine_name}_transitions"

      create_table(table_name, **options.merge!(id: false)) do |td|
        td.references(record_table_name, null: false, index: true)

        td.string(:state, null: false, index: true)
        td.string(:previous_state, null: false, index: true)

        td.json(:arguments) if options[:add_arguments]
        td.json(:change) if options[:add_changes]

        precision = supports_datetime_with_precision? && 6

        td.datetime(:created_at, null: false, index: true, precision: precision)
        td.datetime(:effective_at, null: false, index: true, precision: precision)

        yield td if block_given?
      end
    end

    # persist per-record transitions
    ## student = Student.find_by(name: "James")
    ## def Student.enroll, Student.expect, Student.graduate
    ##   ..
    ##   student.create_enrollment!(name: "enrolled", effective_date: 2004)
    ##   ..
    ##   student.create_enrollment!(name: "expected", effective_date: 2008)
    ##   ..
    ##   student.create_enrollment!(name: "graduated", effective_date: 2006)
    ##   ..
    ## etc etc
  end
end
