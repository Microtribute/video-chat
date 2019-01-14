require 'spec_helper'

describe State do

  context "scopes" do
    it "should provide a with_approved_lawyers scope" do
      scope = State.with_approved_lawyers
      
      scope.joins_values.should eql([:lawyers])
      scope.where_values.should eql(["#{Lawyer.table_name}.is_approved = 1"])
      scope.group_values.should eql(["#{State.table_name}.id"])

      lambda{scope.count}.should_not raise_error
    end

    it "should provide a name_like scope" do

      scope = State.name_like("x y z ")
      
      scope.where_values.should eql([
        "#{State.table_name}.name LIKE 'x y z'"
      ])
      
      lambda{scope.count}.should_not raise_error

    end

  end

end