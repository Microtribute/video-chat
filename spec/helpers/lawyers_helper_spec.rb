require 'spec_helper'

describe LawyersHelper do

  context "#selected_offerings_caption" do

    it "should display text when no results are returned" do
      assign(:search, stub(:total => 0))
      helper.selected_lawyers_caption.should eql(
        "There are no lawyers who can offer you legal advice right now."
      )
    end

    it "should display a count of lawyers when no state, area or subarea are
      selected" do

      assign(:search, stub(:total => 1))
      helper.selected_lawyers_caption.should eql(
        "There is 1 lawyer who can offer you legal advice right now."
      )

    end

    it "should use correct grammer when multiple lawyers are found" do
      assign(:search, stub(:total => 3))
      helper.selected_lawyers_caption.should eql(
        "There are 3 lawyers who can offer you legal advice right now."
      )
    end

    it "should display the state you have selected when applicable" do

      assign(:search, stub(:total => 1))
      assign(:selected_state, State.new(:name => "New York"))

      helper.selected_lawyers_caption.should eql(
        "There is 1 New York lawyer who can offer " + 
        "you legal advice right now."
      ) 
    end

    it "should display the name of the practice area if it is selected" do
      assign(:search, stub(:total => 1))
      helper.stubs(:params => {:practice_area => "Blah Blah"})

      helper.selected_lawyers_caption.should eql(
        "There is 1 blah blah lawyer who can offer " + 
        "you legal advice right now."
      )
    end

    it "should display the name of the practice area and its parent area if 
      a the selected area has a parent" do

      pa = PracticeArea.new(:name => "Blah Blah")
      pa.stubs(:parent_name => "Foo Bar")

      assign(:search, stub(:total => 1))
      assign(:selected_practice_area, pa)      

      helper.stubs(:params => {:practice_area => "Foo Bar"})

      helper.selected_lawyers_caption.should eql(
        "There is 1 foo bar lawyer who can offer " + 
        "you legal advice on blah blah right now."
      )

    end



  end

end