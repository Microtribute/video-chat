require 'spec_helper'

describe PracticeArea do
  
  context "associations" do
    it "should provide an association to find its children" do
    
      proxy = PracticeArea.reflect_on_association(:children)

      proxy.macro.should be :has_many
      proxy.options[:foreign_key].should eql :parent_id
      proxy.options[:class_name].should eql "PracticeArea"
      
      lambda{PracticeArea.new.children}.should_not raise_error
    end
  end

  context "scopes" do

    it "should provide a scope for practice areas with approved lawyers" do
      scope = PracticeArea.with_approved_lawyers
      scope.joins_values.should eql([:lawyers])
      scope.group_values.should eql(["#{PracticeArea.table_name}.id"])
      scope.where_values.should eql(["#{Lawyer.table_name}.is_approved = 1"])
    end

    context ".name_like" do
      
      it "should provide a scope for practice areas with names like x" do
        scope = PracticeArea.name_like("My-Dasherized-name")
        scope.where_values.should eql([
          "LOWER(name) REGEXP '^my[ \-\/]+dasherized[ \-\/]+name$'"
        ])
        lambda{scope.count}.should_not raise_error
      end

    end

  end

  context "delegation" do
    
    it "should delegate parent_name to its main_area's name" do
      pa = PracticeArea.new
      parent = PracticeArea.new(:name => "xyz")

      pa.stubs(:main_area => parent)
      pa.parent_name.should be parent.name
    end

  end

  context "is_national?" do
    it "should return false if is_national attribute is nil" do
      business = PracticeArea.new(name: "Business", is_national: nil)
      business.is_national?.should be false
    end
  end
end
