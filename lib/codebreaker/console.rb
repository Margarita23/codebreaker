require_relative './game'
module Codebreaker
  class Console
    def new_game
    puts("Let's play Codebreaker!")
    @game= Codebreaker::Game.new
    end
    def choose_difficalt
      puts("Choose the difficulty level! 1 - easy, 2 - normal, 3 - hard")
      @difficalty = gets.chomp
    end
    def get_secret_code
      @secret_code = @game.start(@difficalty.to_i)
    end
    def make_guess
      puts("Give me your guess")
      @your_guess = gets.chomp
      hint(@your_guess.to_s)
      @your_guess = @your_guess.split("").map { |s| s.to_i }
      @user_code = @game.submit_code(@your_guess)
      @result = @game.check_submit_code
      print (@result)
    end
      def hint(text)
        @text = text
      if @text == "hint"
        puts @game.get_hint
      end
    end
    def save
      puts("Do you want to save your game?(y/n)")
      @y_n = gets.chomp
      if @y_n == ("y")
        puts("Name:")
        @name = gets.chomp
        @game.new_player(@name)
      else
      end
    end
    
    def play
      new_game
      choose_difficalt
      get_secret_code
      loop do
        if @game.loss? || @game.win?
          break
        else
          print @game.instance_variable_get(:@secret_code)
          puts @game.loss?
          puts @game.win?
          make_guess
        end
      end
      puts("You are winner!") if @game.win?
      puts("You are lose!") if @game.loss?
      save
    end
  end
end
r = Codebreaker::Console.new
r.play
