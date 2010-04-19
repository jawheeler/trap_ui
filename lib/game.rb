require 'deck'
require 'proposal'
require 'proposal_manager'
require 'player/player'

class Game
  # Default players
  PLAYERS = [
    Player::Player.new(0,'A'),
    Player::Player.new(1,'B'),
    Player::Player.new(2,'C'),
    Player::Player.new(3,'D'),
    Player::Player.new(4,'E')
  ]

  attr_reader :players, :proposal_manager
  
  def initialize players = PLAYERS, deck_class = Deck
    @players = players
    @deck = deck_class.new(players)
    @proposal_manager = ProposalManager.new(@deck)
  end

  def traps
    @proposal_manager.traps
  end

  def proposals
    @proposal_manager.proposals
  end

end
