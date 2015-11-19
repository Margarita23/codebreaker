require 'spec_helper'
require './lib/codebreaker/game.rb' 
module Codebreaker
  describe Game do
    
    describe "#start" do
      before(:all) do
        game = Codebreaker::Game.new
        @secret_code = game.start
      end
      it "generates secret code" do
        expect(@secret_code).not_to eq(@array_of_digits)
      end
      it "saves 4 numbers secret code" do
        expect(@secret_code.length).to eq(4)
      end
      it "saves secret code with numbers from 1 to 6" do
        @secret_code.each do |x|
          expect(x<=6 ||x>=1).to eq(true)
        end 
      end
    end
    
    describe "#Code-breaker submit guess" do
      before(:all) do
        @game = Codebreaker::Game.new
        @secret_code = @game.start
      end
      it "get 4 numbers from user" do
        @submit_code = @game.submit_code([1,1,1,6])
        expect(@submit_code.size).to eq(@secret_code.size)
      end
      it "get 4 numbers from user" do
        @submit_code = @game.submit_code([1,1,1,6])
        expect(@submit_code.size).to eq(@secret_code.size)
      end
      it "get pluses if index of guessed digits is matches" do
        @submit_code = @game.submit_code(@secret_code)
        @result = @game.get_pluses
        expect(@result).to eq(["+","+","+","+"])
      end
      it "get the right results in the comparison of the alleged code and secret code" do
      end

    end
    
    describe "#Code-breaker wins game" do
    end
    
    describe "#Code-breaker loses game" do
    end
    
    describe "#Code-breaker plays again" do
    end
    
    describe "#Code-breaker requests hint" do
    end
    
    describe "#Code-breaker saves score" do
    end
    
  end
end