require 'Singleton'
require 'fx_controller/proposal_controller'

# This Singleton class provides indirection. With a little more work,
# it can be used to invert control and facilitate testing.
# It is responsible for maintaining a mapping between symbols and corresponding
# FXController classes.
#
# Views can initiate controller actions using something like:
# FXController::Dispatcher.go(:controller).action
module FXController
  class Dispatcher
    include Singleton
    
    def initialize
      # TODO Load automatically with configuration
      @controllers = {
        :proposal => ProposalController
      }
    end

    def dispatch name_sym
      # Return an instance of the controller associated with name_sym
      if clazz = @controllers[name_sym]
        clazz.send(:instance)
      end
    end
    
    def self.go name_sym
      Dispatcher.instance.dispatch(name_sym)
    end

  end
end
