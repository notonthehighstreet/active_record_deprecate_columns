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
      t.string :nothing
      t.string :with_block
      t.string :with_fallback
      t.string :with_block_and_fallback
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
      expect(BrandNewObject.deprecated_columns).to be_empty
    end
  end

  describe "the User class" do
    let(:user) { User.new }

    context "non-deprecated columns" do
      it "do not raise errors" do
        expect { user.name }.not_to raise_error
      end
    end

    context "with deprecated columns" do
      it "has deprecated columns" do
        expect(User.deprecated_columns).to match_array(%w[old_name nothing with_block with_fallback with_block_and_fallback])
      end

      it "doesn't include the deprecated columns in #to_json" do
        expect(user.as_json.keys).to match_array(%w[id name email])
      end

      it "by default a deprecated column does not raise errors, but returns nil" do
        expect(user.nothing).to be_nil
      end

      it "behaves as specified by the Proc specified by the with_block: parameter" do # see models.rb
        expect { user.old_name }.to raise_error(NoMethodError)
        expect { user.with_block }.to raise_error("specific error")
      end

      it "falls back to the message specified by the fallback: parameter" do
        expect(user.with_fallback).to eq(user.name)
        expect(user.with_block_and_fallback).to eq("SET")
      end
    end
  end

  describe "Vehicle" do
    it "has not_used deprecated" do
      expect(Vehicle.deprecated_columns).to eq(["not_used"])
      expect { Vehicle.new.name }.not_to raise_error
      expect { Vehicle.new.not_used }.to raise_error(NoMethodError)
    end

    context "when loading object from the database" do
      it "column is still deprecated" do
        Vehicle.deprecate_column :sometimes_used
        Vehicle.create(name: "Audi", sometimes_used: "yes")
        vehicle = Vehicle.last
        expect(vehicle.name).to eq("Audi")
        expect(vehicle.sometimes_used).to be_nil
      end
    end
  end

  describe "subclass of existing class" do
    it "raises an error if trying to deprecate a column" do
      expect { Class.new(Vehicle).deprecate_column("sometimes_used") }.to raise_error("You can only deprecate columns on the superclass")
    end
  end
end
