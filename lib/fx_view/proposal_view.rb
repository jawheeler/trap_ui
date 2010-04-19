require 'fx_controller/dispatcher'
require 'fx_view/trap_target_view'
require 'fx_view/trap_release_view'

# This view displays a single Proposal. Clicking on a target or release in
# the proposal removes it from the proposal.
module FXView
  class ProposalView < FXHorizontalFrame
    
    def initialize *args
      super(*args)
      self.backColor = FXRGB(180,180,180)
      @proposal = nil
    end

    # Re-create the proposal view using a proposal model
    def render model
      self.model=model
      self.create
    end

    # TODO This could be private, maybe.
    def model= model
      @player = model[:player]
      @proposal = model[:proposal]

      # Remove all the old widgets.
      # TODO instead of recreating everything from scratch, we could reuse some
      # of the old widgets.
      self.children.each do |c|
        self.removeChild(c)
      end

      # Add a TrapTargetView for each target in the proposal.
      @proposal.target_traps.each_with_index do |tt,i|
        ttv = TrapTargetView.new(tt, @proposal.target_players[i], self, :opts => LAYOUT_SIDE_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
            :width => self.height,
            :height => self.height
        )
        # Clicking the target trap will remove it from this proposal.
        ttv.click_lambda = lambda {
          FXController::Dispatcher.go(:proposal).remove_target(@player,tt)
        }
      end

      # Add a TrapReleaseView for each release in the proposal
      @proposal.release_traps.each do |rt|
        trv = TrapReleaseView.new(rt, self, :opts => LAYOUT_SIDE_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
            :width => self.height,
            :height => self.height
        )
        # Clicking the release trap will remove it from this proposal
        trv.click_lambda = lambda {
          FXController::Dispatcher.go(:proposal).remove_release(@player,rt)
        }
      end
    end

  end
end
