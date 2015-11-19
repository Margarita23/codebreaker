module Codebreaker
  class Game
    attr_accessor :dificalty
    def generate_code
      @num =  4
      @from = 1
      @to = 6
      @array_of_digits = @num.times.map{@from + Random.rand(@to)}
    end
    
    #dificalty may be 1 = easy, 2 = normal, 3 = hard
    def dificalty(value = 1)
      @value = value
      case @value
      when 1
        @hint, @attempts = 1, 15
      when 2
        @hint, @attempts = 1, 10
      when 3
        @hint, @attempts = 1, 6
      end
    end
    
    def start
      @secret_code = self.generate_code
    end
    
    def submit_code(guess)
      @guess = guess
      @guess
    end
    
    
    def get_pluses
      @res = []
      @guess.each_index{|i| @res.push('+') if @guess[i]==@secret_code[i]}
      @res
    end
    
    def check_submit_code
      
    end
  end
end

