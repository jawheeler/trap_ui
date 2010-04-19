# A view of a Targetted Trap. The click_lambda may be set to perform an action
# when the trap is clicked.
module FXView
  class TrapTargetView < TrapView
    
    attr_accessor :click_lambda

    def initialize target_trap, target_player, *args
      super(*args)
      @target_trap = target_trap
      @target_player = target_player
      @click_lambda = lambda {}
    end

    def do_paint sender, selector, event
      FXDCWindow.new(self) do |dc|
        dc.foreground = self.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
        draw_trap_target(dc, @target_trap, @target_player)
      end
      
    end

    def do_motion sender, selector, event
      # nothing
    end

    def do_click sender, selector, event
      @click_lambda.call
    end
  end
end
