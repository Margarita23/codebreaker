require_relative './game'
module Codebreaker
  class Console
    def new_game
      @game= Codebreaker::Game.new
    end
    def choose_difficalt(difficalty)
      @diff = difficalty.to_i
    end
    def get_secret_code
      @secret_code = @game.start(@diff)
    end
    def make_guess(your_guess)
      @your_guess = your_guess
      @your_guess = @your_guess.split("").map { |s| s.to_i }
      @user_code = @game.submit_code(@your_guess)
    end
    def get_result
      @result = @game.check_submit_code
    end
    def hint
      @hint = @game.get_hint
    end
    def save(name)
        @game.new_player(name)
    end
    def play
      puts("Let's play Codebreaker!")
      new_game
      puts("Choose the difficulty level! 1 - easy, 2 - normal, 3 - hard")
      difficalty = gets.chomp
      choose_difficalt(difficalty)
      get_secret_code
      loop do
        if @game.loss? || @game.win?
          break
        else
          puts("Give your guess")
          @your_guess = gets.chomp
          if @your_guess=="hint"
            puts(hint)
          else
            make_guess(@your_guess)
            puts(get_result)
          end
        end
      end
      puts("You are winner!") if @game.win?
      puts("You are lose!" + "#{@game.instance_variable_get(:@secret_code)}") if @game.loss?
      puts("Do you want to save your game?(y/n)")
      @y_n = gets.chomp
        if @y_n == ("y")
          puts("Name:")
          @name = gets.chomp
          save(@name)
        end
    end
  end
end
#r = Codebreaker::Console.new
#r.play
