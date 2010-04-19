require 'Singleton'

# This Singleton class provides indirection. With a little more work,
# it can be used to invert control and facilitate testing.
# It is responsible for maintaining a mapping between symbols and corresponding
# FXView classes.
#
# Controllers can initiate view updating using something like:
# FXView.ViewResolver.render(:view, model, {:another_model => another_model})
module FXView
  class ViewResolver
    include Singleton

    def initialize
      # TODO Load automatically with configuration
      @views = {}
    end

    # renders a view that was previously registered, using the passed model(s).
    def self.render name_sym, model = nil
      ViewResolver.instance.render(name_sym,model)    
    end
    
    def render name_sym, model = nil
      @views[name_sym].render(model)
    end

    # Registers a view under a name symbol, and returns the ViewResolver instance
    def self.register name_sym, view
      out = ViewResolver.instance
      out.register(name_sym,view)
      out
    end

    def register name_sym, view
      @views[name_sym] = view
    end
  end
end
