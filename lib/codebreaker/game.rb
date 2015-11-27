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
      raise TypeError, 'difficalt should be 1,2,3' if !(1..3).cover?(value.to_i)
      @hint = 1
      @value = value.to_i
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
    def start(difficalt = 1)
      difficalty(difficalt)
      @attempts = @att
      @time = Time.now.strftime("%d/%m/%Y %H:%M")
      @secret_code = generate_code
    end
    #---------Code-breaker submit guess
    def submit_code(guess)
      raise ArgumentError, 'Should be an array of four elements' if guess.length != NUM_COUNT
      @guess = guess
      if !loss?
        @attempts = @attempts - 1
        check_submit_code
      end
      @guess = guess
    end
    def check_submit_code
      @res_plus,@res_minus, @without_plus_sec, @without_plus_sub  = [], [], [], []
      @secret_code.each_index do |i| 
        if @guess[i] == @secret_code[i]
          @res_plus.push("+")
        else
          @without_plus_sec.push(@secret_code[i])
          @without_plus_sub.push(@guess[i])
        end
      end
  
      @without_plus_sub.each_index do |i|
        @without_plus_sec.each_index do |j|
          if @without_plus_sec[j] == @without_plus_sub[i]
            @res_minus.push("-")
            @without_plus_sec.delete_at(j)
            @without_plus_sub.delete_at(i)
          end
        end
      end
      @result = @res_plus + @res_minus
    end
    #---------Code-breaker wins game
    def win?
      @result == ["+","+","+","+"]
    end
    #---------Code-breaker loses game
    def loss?
      @attempts==0
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
      raise 'Missing name' if name == ""
      @use_attempts = @att - @attempts
      win? ? @res_game = "win" : @res_game = "lose"
      File.open("./players_data/#{name}_data.txt", "a") do |i|
        i.puts(@time +" / " + @use_attempts.to_s + " / " + @res_game)
      end
    end
    
  end
end
