# To change this template, choose Tools | Templates
# and open the template in the editor.

class Trap

  attr_reader :captives, :captors, :proposal_refs

  # captives and captors are arrays of players
  def initialize captives, captors
    @captives = captives.sort
    @captors = captors.sort
    @captives_set = Set.new(captives)
    @captors_set = Set.new(captors)
    @proposal_refs
  end

  # oks is a set of players
  def target? oks
    # All captors must agree to target
    oks.superset?(self.captors_set)
  end

  # oks is a set of players
  def release? oks
    !( (self.captors_set & oks).empty? )
  end

  def to_s
    self.captives.join+'/'+self.captors.join
  end

  def eql? other
    self.captives.eql?(other.captives) &&
    self.captors.eql?(other.captors)
  end

  def hash
    (self.captives.hash + 11*self.captors.hash)
  end

end
