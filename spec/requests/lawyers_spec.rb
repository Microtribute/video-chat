require 'spec_helper'

describe "Restful Lawyers", :integration do


  before(:each) do
    Lawyer.delete_all
  end

  let(:practice_area) do
    FactoryGirl.create(:practice_area)
  end

  context "Signing up" do

    it "should create a lawyer" do
      
      lawyer = FactoryGirl.build(:lawyer)

      # create a practice area to select
      practice_area

      lambda{
        visit(new_lawyer_path)
        fill_in("lawyer_first_name", :with => lawyer.first_name)
        fill_in("lawyer_last_name", :with => lawyer.last_name)
        fill_in("lawyer_email", :with => lawyer.email)
        fill_in("lawyer_password", :with => lawyer.password)
        fill_in("lawyer_rate", :with => "200")
        
        check("practice_area_#{practice_area.id}")
        click_button("Apply as a Lawyer")
        
        # base case redirects to lawyers path
        page.current_path.should eql(subscribe_lawyer_path)

        Lawyer.last.practice_areas.should include practice_area

      }.should change{Lawyer.count}.by(1)
    end 

    it "should display error messages when a user fails to be 
      created" do

      lawyer = FactoryGirl.build(:lawyer)

      lambda{
        visit(new_lawyer_path)
        fill_in("lawyer_first_name", :with => lawyer.first_name)
        fill_in("lawyer_last_name", :with => lawyer.last_name)
        fill_in("lawyer_password", :with => lawyer.password)
        click_button("Apply as a Lawyer")
        
        # should render template with error message
        page.should have_selector("div.error_explanation") do
          with_selector("li", :text => "Email is required")
        end

      }.should change{Lawyer.count}.by(0)

    end

  end

end