module Codebreaker
  NUM_COUNT = 4
  FROM = 1
  TO = 6
  class Game
    
    def generate_code
      @array_of_digits = NUM_COUNT.times.map{FROM + Random.rand(TO)}
    end

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

    def start(difficalt = 1)
      difficalty(difficalt)
      @attempts = @att
      @time = Time.now.strftime("%d/%m/%Y %H:%M")
      @secret_code = generate_code
    end

    def submit_code(guess)
      raise ArgumentError, 'Should be an array of four elements' if guess.length != NUM_COUNT
      @ultimate_result = []
      @guess = guess
      if !loss?
        @attempts = @attempts - 1
      end
    end
    
    def check_submit_code
      @res_plus,@res_minus = [], []
      secret = @secret_code
      guess = @guess
      NUM_COUNT.times do
        secret.each_index do |i| 
          if guess[i] == secret[i]
            @res_plus.push("+")
            guess.delete_at(i)
            secret.delete_at(i)
          end
        end
      end
      NUM_COUNT.times do
        guess.each_index do |i|
          secret.each_index do |j|
            if guess[i] == secret[j]
              secret.delete_at(j)
              guess.delete_at(i)
              @res_minus.push("-")
            end
          end
        end  
      end
      @result = @res_plus + @res_minus
    end
    
    def win?
      @result == ["+","+","+","+"]
    end
    
    def loss?
      @attempts==0
    end
    
    def get_hint
      if @hint !=0
      position = 0 + Random.rand(NUM_COUNT)
        @hint-=1
        @secret_code[position]
      end
    end
    
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
