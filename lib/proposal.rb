require 'Set'
require 'player/player'

# A Proposal represents a proposed resolution for a collection of traps.
# Each trap can either be targeted at one of its captives, or released.
class Proposal

  def initialize proposal_manager
    @manager = proposal_manager
    @trap_resolutions = []
    @oks = Set.new
  end

  def all_traps
    @manager.traps.reject do |t|
      @trap_resolutions[@manager.trap_to_index[t]].nil?
    end
  end

  def target_traps
    out = @manager.traps.select do |t|
      @trap_resolutions[@manager.trap_to_index[t]].is_a?(Player::Player)
    end
    out
  end

  def target_players
    out = @trap_resolutions.select do |tr|
      tr.is_a?(Player::Player)
    end
    out
  end

  def release_traps
    out = @manager.traps.select do |t|
      @trap_resolutions[@manager.trap_to_index[t]]==:release
    end
    out
  end

  # Add a targetted trap to this proposal and return self
  def add_target trap, player
    if trap.captives.include?(player)
      @trap_resolutions[@manager.trap_to_index[trap]]=player
    else
      raise "Invalid target #{player} for trap #{trap}."
    end
    self
  end

  # Remove a targetted trap to this proposal and return self
  def remove_target trap
    @trap_resolutions[@manager.trap_to_index[trap]] = nil
    self
  end

  # Add a released trap to this proposal and return self
  def add_release trap
    @trap_resolutions[@manager.trap_to_index[trap]] = :release
    self
  end

  # Remove a released trap from this proposal and return self
  def remove_release trap
    @trap_resolutions[@manager.trap_to_index[trap]] = nil
    self
  end

  def approve player
    @oks << player
    self
  end

  def disapprove player
    @oks.delete(player)
    self
  end

  # Are the oks sufficient to approve this proposal?
  def approved?
    @target_traps.each do |e|
      return false unless e.target? @oks
    end
    @release_traps.each do |r|
      return false unless r.release? @oks
    end
    return true
  end

  def score
    target_players.each do |p|
      p.score_target
    end
  end

  def to_s
    @manager.traps.map{|t|
      i = @manager.trap_to_index[t]
      case @trap_resolutions[i]
      when :release
        "#{t}!"
      when nil
        nil
      else
        "#{t}:#{@trap_resolutions[i]}"
      end
    }.compact.join(' ')
  end

  def eql? other
    target_players == other.target_players &&
    target_traps == other.target_traps &&
    release_traps == other.release_traps
  end
end
