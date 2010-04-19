require 'fox16'
require 'fx_controller/dispatcher'
require 'fx_view/trap_view'

include Fox
include FXController

# This view displays all the current traps in the game. These traps can be
# used to create proposals.
module FXView
  class TrapListView < FXHorizontalFrame

    def initialize *args
      super(*args)
      self.backColor = FXRGB(180,180,180)
      @traps = []
      @player = nil
    end

    def render model
      self.model=model
      self.create
    end

    # TODO This could be private.
    def model=(model)
      unless model.nil?
        @player = model[:player] unless model[:player].nil?
        @traps = model[:traps] unless model[:traps].nil?
      end
      children = self.children
      if @traps.length > children.length
        for i in children.length...@traps.length do
          TrapView.new(self, :opts => LAYOUT_SIDE_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
            :width => self.height,
            :height => self.height
          )
        end
      elsif children.length > @traps.length
        for i in @traps.length...children.length
          children[i].destroy
        end
      end
      children = self.children
      @traps.each_with_index do |t,i|
        children[i].trap = t

        children[i].release_lambda = lambda {
          Dispatcher.go(:proposal).add_release @player, t
        }
        children[i].target_lambda = lambda { |target_player|
          Dispatcher.go(:proposal).add_target @player, t, target_player
        }
      end
    end
  end
end
