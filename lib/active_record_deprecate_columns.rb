require "active_record_deprecate_columns/version"

module ActiveRecordDeprecateColumns
  def deprecate_column(name)
    raise "You can only deprecate columns on the superclass" if self.superclass != ActiveRecord::Base
    @_deprecated_columns ||= []
    @_deprecated_columns << name.to_s
  end

  def deprecated_columns
    @_deprecated_columns || []
  end

  def columns
    super.reject {|c| deprecated_columns.include?(c.name) }
  end
end
