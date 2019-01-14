require 'spec_helper'

describe Lawyer do
  DatabaseCleaner.clean

  before(:each) do
    subject.stubs(:time_zone => "Eastern Time (US & Canada)")
    Time.zone = "Eastern Time (US & Canada)"
  end

  subject { FactoryGirl.create(:lawyer) }
  specify { should have_many(:bar_memberships) }
  specify { should have_many(:conversations) }
  specify { should have_many(:bids) }
  specify { should have_many(:messages) }
  specify { should have_many(:daily_hours) }
  specify { should have_many(:expert_areas) }
  specify { should have_many(:practice_areas) }
  specify { should have_many(:reviews) }
  specify { should have_many(:states) }
  specify { should have_one(:homepage_image) }
  specify { should validate_presence_of(:payment_status) }
  specify { should ensure_inclusion_of(:payment_status).in_array(Lawyer::PAYMENT_STATUSES) }
  specify { should be_valid }
  specify { should accept_nested_attributes_for(:bar_memberships) }

  describe "search", :integration do

    before(:each) do
      Lawyer.delete_all
      Lawyer.solr_remove_all_from_index!
    end 
  
    describe "Availability toggles" do
      it "should sort right" do
        lawyer1 = FactoryGirl.create(:lawyer, :first_name => 'First keyword', :is_online => false, :is_available_by_phone => false)
        lawyer2 = FactoryGirl.create(:lawyer, :first_name => 'Second keyword', :is_online => true, :is_available_by_phone => false)
        lawyer3 = FactoryGirl.create(:lawyer, :first_name => 'Third keyword', :is_online => true, :is_available_by_phone => true)
        subject.reindex!
        search = Lawyer.build_search('keyword').execute
        Lawyer.all.count.should == 3
        lawyers = search.results
        search.results.count.should == 3
        lawyers.first.should == lawyer3
        lawyers.last.should == lawyer1
        lawyer1.update_attribute(:is_online, true)
        lawyer2.update_attribute(:is_online, false)
        search = Lawyer.build_search('keyword').execute
        lawyers = search.results
        lawyers.last.should == lawyer2
      end
    end
  
    it "Search results must not contains :payment_status => :unpaid, :is_approved => false lawyers" do
      lawyer1 = FactoryGirl.create(:lawyer, :first_name => 'First keyword', :payment_status => 'unpaid', :is_approved => false)
      lawyer2 = FactoryGirl.create(:lawyer, :first_name => 'Second keyword', :payment_status => 'unpaid', :is_approved => true)
      lawyer3 = FactoryGirl.create(:lawyer, :first_name => 'Third keyword', :payment_status => 'free', :is_approved => true)
      lawyer4 = FactoryGirl.create(:lawyer, :first_name => 'Fourth keyword', :payment_status => 'paid', :is_approved => true)
      lawyer5 = FactoryGirl.create(:lawyer, :first_name => 'Fifth', :payment_status => 'paid', :is_approved => true, :stripe_card_token => 'FwZ_fj0l1fZw36bVmrg-Rg', :stripe_customer_token => 'cus_0MXYFpVxum69S5' )
      subject.reindex!
      search = Lawyer.build_search('keyword').execute
      Lawyer.all.count.should == 5
      Lawyer.paid.count.should == 1
      Lawyer.unpaid.count.should == 2
      Lawyer.free.count.should == 1
      Lawyer.approved_lawyers == 3
      Lawyer.shown == 3
      lawyers = search.results
      search.results.count.should == 2
    end

    describe "Availability toggles" do
      it "should be valid" do
        lawyer1 = FactoryGirl.create(:lawyer, :first_name => 'First keyword', :is_online => false, :is_available_by_phone => false)
        lawyer2 = FactoryGirl.create(:lawyer, :first_name => 'Second keyword', :is_online => true, :is_available_by_phone => false)
        lawyer3 = FactoryGirl.create(:lawyer, :first_name => 'Third keyword', :is_online => true, :is_available_by_phone => true)
        subject.reindex!
        search = Lawyer.build_search('keyword').execute
        Lawyer.all.count.should == 3
        lawyers = search.results
        search.results.count.should == 3
        lawyers.first.should == lawyer3
        lawyers.last.should == lawyer1
        lawyer1.update_attribute(:is_online, true)
        lawyer2.update_attribute(:is_online, false)
        search = Lawyer.build_search('keyword').execute
        lawyers = search.results
        lawyers.last.should == lawyer2
      end
    end
  
    it "Search results must not contains :payment_status => :unpaid, :is_approved => false lawyers" do
      lawyer1 = FactoryGirl.create(:lawyer, :first_name => 'First keyword', :payment_status => 'unpaid', :is_approved => false)
      lawyer2 = FactoryGirl.create(:lawyer, :first_name => 'Second keyword', :payment_status => 'unpaid', :is_approved => true)
      lawyer3 = FactoryGirl.create(:lawyer, :first_name => 'Third keyword', :payment_status => 'free', :is_approved => true)
      lawyer4 = FactoryGirl.create(:lawyer, :first_name => 'Fourth keyword', :payment_status => 'paid', :is_approved => true)
      lawyer5 = FactoryGirl.create(:lawyer, :first_name => 'Fifth', :payment_status => 'paid', :is_approved => true, :stripe_card_token => 'FwZ_fj0l1fZw36bVmrg-Rg', :stripe_customer_token => 'cus_0MXYFpVxum69S5' )
      subject.reindex!
      search = Lawyer.build_search('keyword').execute
      Lawyer.all.count.should == 5
      Lawyer.paid.count.should == 1
      Lawyer.unpaid.count.should == 2
      Lawyer.free.count.should == 1
      Lawyer.approved_lawyers == 3
      Lawyer.shown == 3
      lawyers = search.results
      search.results.count.should == 2
    end

    describe "search by state" do

      it "should find by state" do
        FactoryGirl.create(:state, :name => 'Arizona')
        state = FactoryGirl.create(:state, :name => 'Pennsylvania')
        state2 = FactoryGirl.create(:state, :name => 'Arizona')
        subject.states<< state
        subject.states<< state2
        subject.states.count.should == 2
        subject.state_names.should == "#{state.name},#{state2.name}"
        assert subject.reindex!
        search = Lawyer.search do
          with(:state_ids, [state.id])
        end
        search.total.should == 1
      end

    end

    describe "search by practice_area" do

      it "should find by practice_area" do
        FactoryGirl.create(:practice_area, :name => 'Bankruptcy')
        FactoryGirl.create(:practice_area, :name => 'Business and Startups')
        practice_area = FactoryGirl.create(:practice_area, :name => 'Employment')
        lawyer = FactoryGirl.create(:lawyer, :first_name => 'Robert')
        lawyer.practice_areas << practice_area
        lawyer.save
        assert subject.reindex!
        search = Lawyer.search do
          with :practice_area_ids, [practice_area.id]
        end
        search.total.should == 1
        PracticeArea.name_like(practice_area.name).count.should == 1
      end

    end

    describe "search by keyword" do

      it "should find by keyword" do
        lawyer = FactoryGirl.create(:lawyer, :last_name => 'Find me')
        Lawyer.solr_reindex
        search = Lawyer.search do
          fulltext lawyer.last_name
        end
        search.total.should == 1
      end
    end

  end

  it "should provide a approved_lawyers scope" do
    scope = Lawyer.approved_lawyers
    scope.where_values_hash.should eql(
      :user_type => [User::LAWYER_TYPE], :is_approved => true
    )
    scope.order_values.should include("is_online desc, phone desc")
  end

  it "should provide a paid scope" do
    scope = Lawyer.paid
    scope.where_values_hash.should eql(
      :user_type => [User::LAWYER_TYPE], :payment_status => 'paid'
    )
    scope.where_values.should include("stripe_card_token IS NOT NULL", "stripe_customer_token IS NOT NULL")
  end

  it "should provide a unpaid scope" do
    Lawyer.unpaid.where_values_hash.should eql(
      :user_type => [User::LAWYER_TYPE], :payment_status => 'unpaid'
    )
  end

  it "should provide a free scope" do
    Lawyer.free.where_values_hash.should eql(
      :user_type => [User::LAWYER_TYPE], :payment_status => 'free'
    )
  end

  it "should provide a shown scope" do
    Lawyer.shown.where_values_hash.should eql(
      :user_type => [User::LAWYER_TYPE], 
      :is_approved => true, 
      :payment_status => ['paid', 'free']
    )
  end

  it "should provide an offers_legal_services scope" do
    scope = Lawyer.offers_legal_services
    scope.includes_values.should eql([:offerings])
    scope.where_values.should include("offerings.id IS NOT NULL")
  end

  it "should provide an offers_legal_advice scope" do
    scope = Lawyer.offers_legal_advice
    scope.includes_values.should eql([:practice_areas])
    scope.where_values.should include("practice_areas.id IS NOT NULL")
  end

  context ".practices_in_state" do

    it "should provide a practices_in_state scope" do
      scope = Lawyer.practices_in_state("New York")
      scope.includes_values.should eql([:states])
      scope.where_values.should include("states.name = 'New York'")
    end

    it "should provide a practices_in_state scope" do
      ny = State.new(:name => "New York")
      scope = Lawyer.practices_in_state(ny)
      scope.includes_values.should eql([:states])
      scope.where_values.should include("states.name = 'New York'")
    end

  end

  context ".offers_practice_area" do
    it "should provide an offers_practice_area scope" do
      pa = PracticeArea.new
      pa.stubs(:id => 9489)

      pa2 = PracticeArea.new
      pa2.stubs(:id => 9374)

      pa.stubs(:children => [pa2])

      PracticeArea.expects(:name_like).with("Blah").returns([pa])

      scope = Lawyer.offers_practice_area("Blah")
      scope.includes_values.should eql([:offerings, :practice_areas])

      where_value = "practice_areas.id IN (#{pa.id},#{pa2.id}) " +
          "OR offerings.practice_area_id IN (#{pa.id},#{pa2.id})"

      scope.where_values.should include where_value

      lambda{scope.count}.should_not raise_error

    end

    it "should handle when an instance of PracticeArea is passed" do
      PracticeArea.expects(:name_like).never

      pa = PracticeArea.new(:name => "Blah-Blah")
      pa.stubs(:id => 928)

      scope = Lawyer.offers_practice_area(pa)
      scope.includes_values.should eql([:offerings, :practice_areas])

      where_value = "practice_areas.id IN (928) " + 
        "OR offerings.practice_area_id IN (928)"

      scope.where_values.should include(where_value)
      lambda{scope.count}.should_not raise_error
    end

    it "should handle when an invalid practice area name is passed" do
      PracticeArea.expects(:name_like).with("Blah-Blah").returns([])

      scope = Lawyer.offers_practice_area("Blah-Blah")
      scope.includes_values.should eql([:offerings, :practice_areas])

      where_value =  "practice_areas.id IN (NULL) " + 
        "OR offerings.practice_area_id IN (NULL)"

      scope.where_values.should include(where_value)
      lambda{scope.count}.should_not raise_error
    end
  end

  context "#available_times" do

    let(:time) do
      (Time.now + 1.day).midnight
    end

    let(:daily_hour) do
      DailyHour.new.tap do |dh|
        dh.stubs(
          :wday => time.wday,
          :start_time_on_date => time + 12.hours,
          :end_time_on_date => time + 14.hours
        )
      end
    end

    it "should list available times for a given day in the future" do

      subject.daily_hours << daily_hour

      subject.available_times(time).should eql([
        time + 12.hours,
        time + 12.hours + 30.minutes,
        time + 13.hours,
        time + 13.hours + 30.minutes
      ])

    end


    context "Same Day" do

      let(:time) do
        Time.zone.now.midnight
      end

      it "should only show times at least one hour from now" do
        Time.zone.stubs(:now => time + 12.hours)
        subject.daily_hours << daily_hour
        # only 1pm on is available
        subject.available_times(time).should eql([
          time + 12.hours + 30.minutes,
          time + 13.hours,
          time + 13.hours + 30.minutes
        ])
      end

    end


  end

  context "#daily_hours" do

    context "#on_wday" do

      it "should provide a 'daily_hours_on_wday' method to find valid hours
        for a day" do
        daily_hour = DailyHour.new(:wday => 1)
        subject.daily_hours << daily_hour
        subject.daily_hours_on_wday(1).should eql(daily_hour)
        subject.daily_hours_on_wday(2).should be_nil
      end

    end

    context "#bookable_on_day?" do

      it "should provide a 'bookable_on_day' method to determine if a given
        day can currently be booked" do
        t = Time.zone.now
        Time.zone.stubs(:now => (t.midnight + 22.hours))

        subject.daily_hours << DailyHour.new(
          :wday => t.wday,
          :start_time => 900,
          :end_time => 1800
        )
        subject.bookable_on_day?(t).should be false
        # next week should be good though
        subject.bookable_on_day?(t + 1.week).should be true
      end

      it "should not be bookable_on_day if the found daily_hour is closed" do
        t = Time.zone.now.midnight + 1.day
        subject.daily_hours << DailyHour.new.tap do |dh|
          dh.stubs(
            :wday => t.wday,
            :closed? => true
          )
        end
        subject.bookable_on_day?(t).should be false
      end

    end
  end

  context "#in_time_zone" do

    it "should set to the Lawyer's Time zone" do

      subject.stubs(:time_zone => "Pacific Time (US & Canada)")
      zone = Time.zone
      # it sets the zone
      subject.in_time_zone do
        Time.zone.should_not eql(zone)
      end
      # and it goes back to what it was
      Time.zone.should eql(zone)
    end

  end


  context "#next_available_days" do

    it "should provide a method to get the next days of availability for
      the lawyer" do
      # we set only one open day
      subject.daily_hours << DailyHour.new(
        :wday => 1,
        :start_time => 900,
        :end_time => 1800
      )
      days = subject.next_available_days(4)
      days.each do |day|
        day.wday.should eql(1)
      end
    end

    it "should not show days that are unavailable because it is too late
      to book" do
      t = Time.zone.now
      Time.zone.stubs(:now => (t.midnight + 18.hours))
      subject.daily_hours << DailyHour.new(
        :wday => t.wday,
        :start_time => 900,
        :end_time => 1830
      )

      subject.next_available_days(1).first.should_not eql(t.to_date)
    end

  end

  context "#is_available_by_phone?" do

    around(:each) do |example|
      t = Time.zone.now
      Timecop.freeze(Time.zone.local(t.year, t.month, t.day, 14, 0, 0)) do
        example.run
      end
    end

    before :each do
      @steven = FactoryGirl.create(
        :lawyer, 
        first_name: "Steven"
      )
    end

    it "should return true if current time is between 
      lawyer's daily hours" do
      
      daily_hour = FactoryGirl.create(
        :daily_hour, 
        lawyer_id: @steven.to_param, 
        wday: Time.zone.now.wday, 
        start_time: 1000, 
        end_time: 1800
      )
      @steven.is_available_by_phone?.should be_true
    end

    it "should return true if lawyer has no daily hours" do
      @steven.daily_hours.delete_all
      @steven.is_available_by_phone?.should be_true
    end

    it "should return false if current time is not 
      between lawyer's daily hours" do
      daily_hour = FactoryGirl.create(
        :daily_hour, 
        lawyer_id: @steven.to_param, 
        wday: Time.zone.now.wday, 
        start_time: 1600, 
        end_time: 1800
      )
      @steven.reload.is_available_by_phone?.should be_false
    end
  end

  context "stripe", :integration do

    before :all do
      @steven = FactoryGirl.create( :lawyer, :payment_status => 'paid')
    end

    it "should create stripe_card_token" do 
      @steven.create_stripe_test_card!
      @steven.get_stripe_card.class.should eql(Stripe::Token)
    end

    it "should create customer" do
      @steven.create_stripe_customer!
      @steven.get_stripe_customer.class.should eql(Stripe::Customer)
    end

    it "should delete customer" do
      @steven.delete_stripe_customer!
      @steven.get_stripe_customer.should be_nil
    end

    it "should subscribe lawyer on plan 3"
    it "should cancel subscribe lawyer"
    it "should create unpaid invoce"
    it "should delete user invoces"
    it "should update lawyer payment status"
    it "should delete stripe customer"

  end

end
