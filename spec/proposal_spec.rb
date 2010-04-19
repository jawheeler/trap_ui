require File.dirname(__FILE__) + '/../lib/proposal'
require File.dirname(__FILE__) + '/../lib/trap'
require 'set'

describe Proposal do
  before(:each) do
    @proposal = Proposal.new([
        Trap.new(['A'],['B','D']),
        Trap.new(['A','B'],['C','D']),
      ],
      ['A','A'],
      [
        Trap.new(['D','B'],['A','C'])
      ]
    )
  end
  
  it "should be valid only if victims are Traps" do
    @proposal.valid?.should == true
    @invalid_proposal = @proposal = Proposal.new([
        Trap.new(['A'],['B','D']),
        Trap.new(['A','B'],['C','D']),
      ],
      ['B','A'],
      [
        Trap.new(['C','B'],['A','B'])
      ]
    )
    @invalid_proposal.valid?.should == false
  end

  it "should be agreed only if target? and release? obtain for oks" do
    @proposal.agreed?(Set.new(['B','C','D'])).should == true
    @proposal.agreed?(Set.new(['B','C','D','E'])).should == true
    @proposal.agreed?(Set.new(['C','D'])).should == false
    @proposal.agreed?(Set.new(['B','D'])).should == false
    @proposal.agreed?(Set.new(['C','B'])).should == false
  end

  it "should have a to_s" do
    @proposal.to_s.should == 'A/BD:A AB/CD:A BD/AC!'
  end

  
end