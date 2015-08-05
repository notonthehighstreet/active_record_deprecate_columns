require 'spec_helper'
require 'active_record'

describe ActiveRecordDeprecateColumns do
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    m = ActiveRecord::Migration
    m.verbose = false

    m.create_table :brand_new_objects do |t|
      t.string :shiny_attribute
    end

    m.create_table :users do |t|
      t.string :name
      t.string :email
      t.string :old_name
      t.string :old_name_as_string
    end

    m.create_table :vehicles do |t|
      t.string :type
      t.string :name
      t.string :not_used
      t.string :sometimes_used
    end
    ActiveRecord::Base.extend ActiveRecordDeprecateColumns
    require_relative 'models'
  end

  describe "BrandNewObject" do
    it "has no deprecated columns" do
      expect(BrandNewObject.deprecated_columns).to eq([])
    end
  end

  describe "User" do
    it "has old_name deprecated" do
      expect(User.deprecated_columns).to eq(["old_name", "old_name_as_string"])
      expect { User.new.old_name }.to raise_error(NoMethodError)
      expect { User.new.old_name_name_as_string }.to raise_error(NoMethodError)
      expect { User.new.name }.not_to raise_error
    end

    it "doesn't include the deprecated columns in #to_json" do
      u = User.new.as_json
      expect(u.keys).to eq(["id", "name", "email"])
    end
  end

  describe "Vehicle" do
    it "has not_used deprecated" do
      expect(Vehicle.deprecated_columns).to eq(["not_used"])
      expect { Vehicle.new.not_used }.to raise_error(NoMethodError)
      expect { Vehicle.new.name }.not_to raise_error
    end
  end

  describe "subclass of existing class" do
    it "raises an error if trying to deprecate a column" do
      expect { Class.new(Vehicle).deprecate_column("sometimes_used") }.to raise_error("You can only deprecate columns on the superclass")
    end
  end
end
