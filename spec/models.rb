class ApplicationRecord < ActiveRecord::Base;
  self.abstract_class = true
end

class BrandNewObject < ApplicationRecord; end

class User < ApplicationRecord
  attr_accessor :attribute
  deprecate_column :nothing
  deprecate_column :old_name, with_block: Proc.new { raise NoMethodError }
  deprecate_column "with_block", with_block: Proc.new { raise "specific error" }
  deprecate_column "with_fallback", fallback: :name
  deprecate_column :with_block_and_fallback, with_block: Proc.new {|object| object.attribute = "SET" }, fallback: :attribute
end

class Vehicle < ApplicationRecord
  deprecate_column :not_used, with_block: Proc.new { raise NoMethodError }
end
