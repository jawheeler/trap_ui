require 'fox16'

include Fox

module FXView
  class TrapView < FXCanvas

    # Player colors
    PALETTE = [
      FXRGB(50,50,50), #dark grey
      FXRGB(150,0,150), #purple
      FXRGB(220,150,0), #orange
      FXRGB(50,170,255), #blue
      FXRGB(255,0,0) #red
    ]

    # Washed-out player colors to designate a released trap.
    RELEASE_PALETTE = [
      FXRGB(200,200,200), #dark grey
      FXRGB(225,187,225), #purple
      FXRGB(245,225,187), #orange
      FXRGB(175,230,255), #blue
      FXRGB(255,187,187) #red
    ]

    #
    # release_lambda lambda {} - lambda should return a controller action to
    #   perform when the user clicks to release
    # target_lambda lambda {|target|} - lambda should return a controller action
    #   to perform when user clicks to target. Target is passed to lambda.
    # TODO trap accessor is probably not needed.
    attr_accessor :trap, :release_lambda, :target_lambda

    def initialize *args
      super(*args)
      @radius = ( self.width < self.height ? 9*self.width/20 : 9*self.height/20)
      @release_lambda = lambda {}
      @target_lambda = lambda {}

      self.backColor = FXRGB(180,180,180)

      self.connect(SEL_PAINT, method(:do_paint))
      self.connect(SEL_MOTION, method(:do_motion))
      self.connect(SEL_LEFTBUTTONRELEASE, method(:do_click))
      self.connect(SEL_LEAVE, method(:do_paint))
      
    end

    def render trap = nil
      self.trap = trap unless trap.nil?
      self.forceRefresh
    end

    # Draw a released trap to the DC (drawing context)
    def draw_trap_release dc, trap
      draw_trap dc, trap, true
    end

    # Draw a targetted trap to the DC
    def draw_trap_target dc, trap, player
      draw_trap dc, trap, false, player
    end

    # Draw a general trap to the DC.
    def draw_trap dc, trap, release = false, target = nil
      draw_captors(dc, trap.captors, 0,0, @radius, release)
      draw_captives dc, trap.captives.to_a.sort, 0, 0, @radius, target
    end

    # What to do if the UI wants to repaint this view
    def do_paint sender, selector, event
      FXDCWindow.new(self) do |dc|
        dc.foreground = self.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)

        @mouseover = :none
        draw_trap(dc, self.trap)

      end
    end

    # What to do if the mouse is moving around this view
    def do_motion sender, selector, event
      target = target_from_event(event)
      old_mouseover = @mouseover
      if target
        @mouseover = target
      elsif release_from_event?(event)
        @mouseover = :release
      else
        @mouseover = :none
      end
      if old_mouseover != @mouseover
        FXDCWindow.new(self) do |dc|
          if @mouseover == :release
            draw_trap_release(dc, self.trap)
          elsif @mouseover == :none
            draw_trap(dc, self.trap, false)
          else
            draw_trap_target(dc, self.trap, @mouseover)
          end
        end
      end
    end

    # What to do if the user clicks on this view
    def do_click sender, selector, event
      case @mouseover
      when :none
        # nothing
      when :release
        @release_lambda.call
      else
        @target_lambda.call @mouseover
      end
    end

    # Calculate which captive (if any) the mouse is pointing at
    # event.
    def target_from_event event
      cp = captive_positions(self.trap.captives.length, 0, 0, @radius)
      r_squared = @radius**2/9
      self.trap.captives.each_with_index do |c,i|
        if (cp[i].x - event.win_x)**2 + (cp[i].y - event.win_y)**2 < r_squared
          return c
        end
      end
      nil
    end

    # True if the mouse is pointing at the release area of this view
    def release_from_event? event
      (event.win_x-@radius)**2 + (event.win_y-@radius)**2 < @radius**2 &&
      (event.win_x-@radius)**2 + (event.win_y-@radius)**2 > (@radius*0.75)**2
    end

    # Draw the captors ring.
    def draw_captors dc, captors, x, y, r, release
      arc_length = 64*360/captors.length # 64ths of degrees
      arc_start = 64*90                  # 64ths of degrees
      captors.each do |c|
        
        if release
          dc.foreground = RELEASE_PALETTE[c.id]
          dc.fillArc(x,y,r*2,r*2,arc_start,arc_length)
        else
          dc.foreground = PALETTE[c.id]
          dc.fillArc(x,y,r*2,r*2,arc_start,arc_length)
        end
        arc_start += arc_length
      end
    end

    # Returns center points of the captives given x, y, and r (allotted radius).
    # This only works for 1, 2, or 3 captives.
    def captive_positions count, x, y, r
      out = []
      case count
      when 1:
        captive_positions = [FXPoint.new(x+r,y+r)]
      when 2:
        captive_positions = [FXPoint.new(x+r/2+5,y+r),FXPoint.new(x+3*r/2-5,y+r)]
      when 3:
        captive_positions = [FXPoint.new(x+r,y+r/2+5),FXPoint.new(x+2*r/3,y+5*r/4),FXPoint.new(x+4*r/3,y+5*r/4)]
      end
    end

    # Draw 1, 2, or 3 captives inside the captors ring.
    def draw_captives dc, captives, x, y, r, target = nil
      dc.foreground = "white"
      dc.fillCircle(x+r,y+r,r-10)

      target_captive_r = r/3
      captive_r = r/4
      cp = captive_positions captives.length, x, y, r
      captives.each_with_index do |c,i|
        dc.foreground = PALETTE[c.id]
        if c == target
          dc.fillCircle(cp[i].x,cp[i].y,target_captive_r)
          dc.foreground = "white"
          dc.fillPolygon(cross_points(cp[i]))
        else
          dc.fillCircle(cp[i].x,cp[i].y,captive_r)
        end
      end
    end

    # Returns points for drawing a cross around the passed point.
    def cross_points point
      return [
        FXPoint.new(point.x-9,point.y-9),
        FXPoint.new(point.x,point.y-3),
        FXPoint.new(point.x+9,point.y-9),
        FXPoint.new(point.x+3,point.y),
        FXPoint.new(point.x+9,point.y+9),
        FXPoint.new(point.x,point.y+3),
        FXPoint.new(point.x-9,point.y+9),
        FXPoint.new(point.x-3,point.y),
      ]
    end
  end
end
