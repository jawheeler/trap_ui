# To change this template, choose Tools | Templates
# and open the template in the editor.

module Player
  class Player
    attr_reader :id, :name
    attr_accessor :score

    def initialize id, name, initial_score = 10
      @id = id
      @name = name
      @score = initial_score
    end

    def score_target
      @score -= 1
    end

    def to_s
      @name
    end

    def <=> other
      self.id <=> other.id
    end
  end
end
