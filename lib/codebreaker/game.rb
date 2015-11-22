module Codebreaker
  NUM_COUNT = 4
  FROM = 1
  TO = 6
  class Game
    def generate_code
      @array_of_digits = NUM_COUNT.times.map{FROM + Random.rand(TO)}
    end
    
    #dificalty may be 1 = easy, 2 = normal, 3 = hard
    def difficalty(value = 1)
      @hint = 1
      @value = value
      case @value
      when 1
        @att = 15
      when 2
        @att = 10
      when 3
        @att = 6
      end
    end
    #---------start
    def start(difficalty = 1)
      self.difficalty(difficalty)
      @attempts = @att
      @time = Time.now.strftime("%d/%m/%Y %H:%M")
      @secret_code = self.generate_code
    end
    #---------Code-breaker submit guess
    def submit_code(guess)
      if loss?
        complete_game
      else
        @guess = guess
        check_submit_code
        win? ? complete_game : @attempts-=1
      end
    end
    
    def get_pluses
      @res_plus = []
      @without_plus_sec = []
      @without_plus_sub = []
      @secret_code.each_index do |i| 
        if @guess[i] == @secret_code[i]
          @res_plus.push("+")
        else
          @without_plus_sec.push(@secret_code[i])
          @without_plus_sub.push(@guess[i])
        end
      end
      @res_plus
    end
    
    def get_minuses
      self.get_pluses
      @res_minus = []
      @no_plus_sub, @no_plus_sec = @without_plus_sub.uniq, @without_plus_sec.uniq
      @no_plus_sub.each do |elem_ub|
        @no_plus_sec.each do |elem_ec|
          if elem_ec == elem_ub
            @res_minus.push("-") 
          end
        end
      end
      @res_minus
    end
    
    def check_submit_code
      self.get_minuses
      @result = @res_plus + @res_minus
    end
    #---------Code-breaker wins game
    def win?
      @result == ["+","+","+","+"] ? true : false
    end
    #---------Code-breaker loses game
    def loss?
      @attempts==0 ? true : false
    end
    #---------Code-breaker plays again
    #---------complete the game
    # 0 - not play again, 1 - play again
    def complete_game
    end
    #---------Code-breaker requests hint
    def get_hint
      if @hint !=0
      position = 0 + Random.rand(NUM_COUNT)
        @hint-=1
        @secret_code[position]
      end
    end
    #---------Code-breaker saves score
    def new_player(name)
      @use_attempts = @att - @attempts
      win? ? @res_game = "win" : @res_game = "lose"
      File.open("../../players_data/#{name}_data.txt", "w") do |i|
        i.puts(@time + @use_attempts.to_s + @res_game)
      end
    end
    
  end
end

