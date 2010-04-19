require 'fox16'
require 'game'
require 'fx_view/view_resolver'
require 'fx_view/trap_list_view'
require 'fx_view/trap_release_view'
require 'fx_view/proposal_view'

include Fox
include FXView

# TODO Much of this initialization should be replaced by a GameController.
# All that should be here is a request to the GameController to display a
# dialog to create a new game.
class TrapWindow < FXMainWindow

  def initialize(app)
    super(app, "Trap", :width => 800, :height => 600)

    begin
      # Construct Trap label
      FXLabel.new(self, "Traps", :opts => JUSTIFY_LEFT|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
      
      # Construct a horizontal frame to display the traps
      trap_list_view = TrapListView.new(self,
        LAYOUT_SIDE_TOP|LAYOUT_FILL_X,
        :height => 100)
      ViewResolver.register( :trap_list, @trap_list_view )

      # Construct Trap label
      FXLabel.new(self, "Proposals", :opts => JUSTIFY_LEFT|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)

      # Construct a horizontal frame to display the proposal builder
      proposal_view = ProposalView.new(self,
        LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT,
        :height => 70)
      ViewResolver.register( :proposal_builder, proposal_view )

      # TODO This is a stop-gap until GameController is made
      game = Dal.instance.game
      trap_list_view.model={:player => game.players[0], :traps => game.traps}

    rescue Exception => e
      puts e.message + "\n" + e.backtrace.join("\n")
    end

  end

  # Create and show the main window
  def create
    super                  # Create the windows
    show(PLACEMENT_SCREEN) # Make the main window appear
  end
end

if __FILE__ == $0
  # Construct the application object
  application = FXApp.new('TrapTest', 'FoxTest')

  # Construct the main window
  window = TrapWindow.new(application)

  # Create the application
  application.create

  # Run the application
  application.run
end