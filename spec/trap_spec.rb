require File.dirname(__FILE__) + '/../lib/trap'
require 'set'

describe Trap do
  before(:each) do
    @trap = Trap.new(Set.new(['A','B']),Set.new(['C','D']))
  end
  
  it "should be released by any captor's ok, ignoring other oks" do
    @trap.release?(Set.new(['A'])).should == false
    @trap.release?(Set.new(['C'])).should == true
    @trap.release?(Set.new(['A','C'])).should == true
    @trap.release?(Set.new(['C','D'])).should == true
  end

  it "should be targetd by ok from all captors, ignoring other oks" do
    @trap.target?(Set.new(['A'])).should == false
    @trap.target?(Set.new(['C'])).should == false
    @trap.target?(Set.new(['A','C'])).should == false
    @trap.target?(Set.new(['C','D'])).should == true
    @trap.target?(Set.new(['C','D','E'])).should == true
  end

  it "should have a to_s" do
    @trap.to_s.should == 'AB/CD'
  end

  
end