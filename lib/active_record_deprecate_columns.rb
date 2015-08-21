require "active_record_deprecate_columns/version"

# To send a notification by default when a deprecated column is accessed, do something like this:
# class ActiveRecord::Base
#   block = lambda do |object, column|
#     Services.for(:error_notification).notify(
#       "OH NO SOMEONE CALLED #{column} from #{caller.join("\n")}"
#     )
#   end
#   def self.deprecate_column(column_name, with_block: block, fallback: nil)
#     super
#   end
# end

module ActiveRecordDeprecateColumns
  def deprecate_column(column_name, with_block: nil, fallback: nil)
    raise "You can only deprecate columns on the superclass" if self.superclass != ActiveRecord::Base

    deprecated_columns << column_name.to_s

    define_method(column_name) do
      with_block.call(self, column_name) if with_block
      public_send(fallback) if fallback
    end
  end

  def deprecated_columns
    @_deprecated_columns ||= []
  end

  def columns
    super.reject {|c| deprecated_columns.include?(c.name) }
  end
end
