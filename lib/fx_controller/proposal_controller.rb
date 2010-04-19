require 'dal'

module FXController
  class ProposalController
    include Singleton

    def initialize
      @dal = Dal.instance
    end

    def new player
      puts "new #{player}"
      
      ViewResolver.render :proposal_builder, @dal.temp_proposal_reset(player)
    end

    def add_target player, target_trap, target_player
      puts "add_target #{player} #{target_trap} #{target_player}"

      ViewResolver.render :proposal_builder,
        :player => player,
        :proposal => @dal.temp_proposal(player).add_target(target_trap, target_player)
    end

    def remove_target player, target_trap
      puts "remove_target #{player} #{target_trap}"

      ViewResolver.render :proposal_builder,
        :player => player,
        :proposal => @dal.temp_proposal(player).remove_target(target_trap)
    end

    def add_release player, release_trap
      puts "add_release #{player} #{release_trap}"

      ViewResolver.render :proposal_builder,
        :player => player,
        :proposal => @dal.temp_proposal(player).add_release(release_trap)

    end

    def remove_release player, release_trap
      puts "remove_release #{player} #{release_trap}"

      ViewResolver.render :proposal_builder,
        :player => player,
        :proposal => @dal.temp_proposal(player).remove_release(release_trap)
    end

    def save player
      puts "save #{player}"
      
      temp = @dal.temp_proposal(player)

      self.new(player)
      ViewResolver.render :proposals_for_game,
        @dal.add_to_game(temp)
    end

    def agree proposal, player
      puts "agree #{proposal} #{player}"

    end

    def unagree proposal, player
      puts "unagree #{proposal} #{player}"
    end

  end
end
