require 'spec_helper'
require './lib/codebreaker/console.rb' 
module Codebreaker
  describe Console do
    before do
      @game = Codebreaker::Console.new
    end
    it "should do new game" do 
      expect(@game.new_game).to be_a(Codebreaker::Game)
    end
    it "should not set the level of difficulty" do
      @game.new_game
      @game.choose_difficult("asd")
      expect{@game.get_secret_code}.to raise_error(TypeError)
    end
    it "should not set the level of difficulty" do
      @game.new_game
      diff = @game.choose_difficult("3try2")
      expect(diff).to eq(3)
    end
    it "should set the level of difficulty" do
      diff = [@game.choose_difficult("3"),@game.choose_difficult("2"),@game.choose_difficult("1")]
      expect(diff).to match([3,2,1])
    end
    describe "secret code, hints and make_guess" do
      before do
        @game = Codebreaker::Console.new
        @game.new_game
        @game.choose_difficult("3")
        @sec_code = @game.get_secret_code
      end
      it "should get secret code than exist 4 digits" do 
        size = @sec_code.size
        expect(size).to eq(Codebreaker::NUM_COUNT)
      end
      it "should give first hint" do 
        hint = @game.hint
        expect(@sec_code).to include(hint)
      end
      it "should not give second hint" do 
        @game.hint
        hint = @game.hint
        expect(hint).to eq(nil)
      end
      it{expect(@game.make_guess("1265")).to eq([1,2,6,5])}
      it{expect{@game.make_guess("12623")}.to raise_error(ArgumentError)}
      it{expect(@game.make_guess("qw12")).to eq([0,0,1,2])}
      it{expect{@game.make_guess("qw125")}.to raise_error(ArgumentError)}
      it{expect{@game.make_guess("25")}.to raise_error(ArgumentError)}
      it "should get result" do
        @game.make_guess("1265")
        expect{@game.get_result}.to change{@game.instance_variable_get(:@result)}
      end
    end
  end
end
