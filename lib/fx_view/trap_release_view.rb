# A view of a Released Trap. The click_lambda may be set to perform an action
# when the trap is clicked.
module FXView
  class TrapReleaseView < TrapView

    attr_accessor :click_lambda

    def initialize trap, *args
      super(*args)
      @trap = trap
      @click_lambda = lambda {}
    end

    def do_paint sender, selector, event
      FXDCWindow.new(self) do |dc|
        dc.foreground = self.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
        draw_trap_release(dc, @trap)
      end
    end

    def do_motion sender, selector, event
      # nothing
    end

    def do_click sender, selector, event
      if (event.win_x-@radius)**2 + (event.win_y-@radius)**2 < @radius**2
        @click_lambda.call
      end
    end
  end
end
