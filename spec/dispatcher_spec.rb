require File.dirname(__FILE__) + '/../lib/fx_controller/dispatcher'
require File.dirname(__FILE__) + '/../lib/fx_controller/proposal_controller'

include FXController

describe Dispatcher do

  it "should map symbols to controller classes" do
    Dispatcher.go(:proposal).should == ProposalController
  end

end
