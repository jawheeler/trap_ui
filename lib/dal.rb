class Dal
  include Singleton

  def initialize
    @proposals_temp = {}
    @game = Game.new
  end

  def temp_proposal player
    @proposals_temp[player] ||= temp_proposal_reset(player)
  end

  def temp_proposal_reset player
    @proposals_temp[player] = Proposal.new(@game.proposal_manager)
  end

  def game
    @game
  end

  def game_proposals
    @game.proposals
  end

end
