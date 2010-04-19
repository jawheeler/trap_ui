# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProposalManager
  attr_reader :traps, :trap_to_index

  def initialize deck
    @deck = deck
    @traps = @deck.new_game
    @trap_to_index = {}
    @traps.each_with_index do |t,i|
      @trap_to_index[t] = i
    end
    @trap_proposals = []
    @proposals = {}
  end

  def proposals
    @proposals.to_a.sort
  end

  def add_proposal proposal
    proposal.all_traps.each do |t|
      i = @trap_to_index[t]
      trap_proposals(i) << proposal
      @proposals << proposal
    end
  end
  
  def execute_proposal proposal
    proposal.score
    proposal.release_traps.each do |rt|
      i = @trap_to_index[rt]
      trap_proposals_clear(i).each do |p|
        @proposals.delete(p)
      end
      @traps[i] = @deck.released(rt)
      @trap_to_index[@traps[i]] = i
    end
    proposal.target_traps.each do |tt|
      i = @trap_to_index[tt]
      trap_proposals_clear(i).each do |p|
        @proposals.delete(p)
      end
      @traps[i] = @deck.targeted(tt)
      @trap_to_index[@traps[i]] = i
    end
  end

  private

  def trap_proposals index
    @trap_proposals[index] ||= []
  end

  def trap_proposals_clear index
    out = trap_proposals(index)
    @trap_proposals[index] = []
    out
  end
end
