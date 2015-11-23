require './game'
puts("Let's play Codebreaker!")
puts("Choose the difficulty level! 1 - easy, 2 - normal, 3 - hard")
difficalty = gets.chomp
@game = Codebreaker::Game.new
@secret_code = @game.start(difficalty)
while !@game.loss?
  puts("Give me your guess")
  @your_guess = gets.chomp
  @your_guess = @your_guess.split("").map { |s| s.to_i }
  user_code = @game.submit_code(@your_guess)
end
