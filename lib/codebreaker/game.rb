module Codebreaker
  NUM_COUNT = 4
  FROM = 1
  TO = 6
  class Game
    def generate_code
      @array_of_digits = NUM_COUNT.times.map{FROM + Random.rand(TO)}
    end
    
    #dificalty may be 1 = easy, 2 = normal, 3 = hard
    def difficalty(value)
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
      difficalty(difficalty)
      @attempts = @att.to_i
      @time = Time.now.strftime("%d/%m/%Y %H:%M")
      @secret_code = generate_code
    end
    #---------Code-breaker submit guess
    def submit_code(guess)
      raise ArgumentError, 'Should be string of four characters' if guess.length != NUM_COUNT
      @guess = guess
      if loss? != true
        @attempts = @attempts - 1
        check_submit_code
      end
    end
    
    def get_pluses
      @res_plus, @without_plus_sec, @without_plus_sub = [], [], []
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
      @res_minus, @minus_sub, @minus_sec = [], [], []
      @un_sec = @without_plus_sec.uniq
      @un_sub = @without_plus_sub.uniq
      @un_sub.each_index do |i|
        @without_plus_sec.each_index do |j|
          if @un_sub[i] == @without_plus_sec[j]
            @minus_sub.push("-")
          end
        end
      end
      @un_sec.each_index do |i|
        @without_plus_sub.each_index do |j|
          if @un_sec[i] == @without_plus_sub[j]
            @minus_sec.push("-")
          end
        end
      end

      if @minus_sub.length <= @minus_sub.length
        @res_minus = @minus_sub
      else
        @res_minus = @minus_sec
      end
      @res_minus
    end
    
    def check_submit_code
      get_pluses
      get_minuses
      @result = @res_plus + @res_minus
    end
    #---------Code-breaker wins game
    def win?
      @result == ["+","+","+","+"]
    end
    #---------Code-breaker loses game
    def loss?
      @attempts == 0
    end
    #---------Code-breaker plays again
    #---------complete the game
  
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
      raise "Missing name" if name == ""
      @use_attempts = @att - @attempts
      win? ? @res_game = "win" : @res_game = "lose"
      File.open("./players_data/#{name}_data.txt", "a") do |i|
        i.puts(@time +" / " + @use_attempts.to_s + " / " + @res_game)
      end
    end
    
  end
end
