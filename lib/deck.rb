require 'trap'
require 'set'

# Deck produces traps based on the players it was constructed with.
class Deck
  TRAP_TYPE = Struct.new('TrapType',:captives,:captors)
  attr_reader :players
  def initialize players
    @players = players
    # Keeps track of the traps currently in play to make sure that
    # two identical traps are not generated.
    @current = Set.new
  end

  # A new game starts with one trap per player, guaranteeing that every
  # player is a captor at least once.
  def new_game
    out = []
    self.players.each do |p|
      out << targeted(p)
    end
    out
  end

  # Generate a trap to replace a successfully targeted trap
  def targeted player, trap=nil
    out = nil
    while (out == nil || @current.include?(out))  do    
      out = trap_for player
    end
    @current.delete(trap) unless trap==nil
    @current << out
    out
  end

  # Generate a trap to replace a released trap
  def released trap=nil
    out = nil
    while (out == nil || @current.include?(out))  do
      out = trap_for nil
    end
    @current.delete(trap) unless trap==nil
    @current << out
    out
  end

  def trap_for player
    trap_type = self.trap_type
    ps = self.shuffled_players(player)
    ps[trap_type[0]+trap_type[1]-1] = ps[ps.length-1] if player
    Trap.new(
      Set.new(ps[0,trap_type.captives]),
      Set.new(ps[trap_type.captives,trap_type.captors])
    )
  end

  def trap_type
    captors = rand(3).floor + 1
    max_captives = self.players.length - captors
    max_captives = 3 if max_captives > 3
    captives = rand(max_captives).floor + 1
    TRAP_TYPE.new(captives,captors)
  end

  # Produces an array of the players shuffled. If a player is passed, that
  # player is guaranteed to appear last in the array.
  def shuffled_players player = nil
    out = self.players.clone
    out.sort_by { |p| p == player ? 2 : rand }
  end

  
end
