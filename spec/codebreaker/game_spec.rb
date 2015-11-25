require 'spec_helper'
require './lib/codebreaker/game.rb' 
module Codebreaker
  describe Game do
    before(:all) do
        @game = Codebreaker::Game.new
        @secret_code = @game.start
      end
    describe "#start" do
      it "generates secret code" do
        expect(@secret_code).to eq(@game.instance_variable_get(:@array_of_digits))
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
      before(:each) do
        @secret_code = @game.start
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
      end
      it "get 4 numbers from user" do
        @submit_code = @game.submit_code([1,1,1,6])
        expect(@submit_code.size).to eq(@secret_code.size)
      end
      describe "an exact match:" do
        it "gets four pluses if four numbers of indices are the same" do
          @game.submit_code([1,2,3,4])
          result = @game.get_pluses
          expect(result).to eq(["+","+","+","+"])
        end
        it "gets three pluses if three numbers of indices are the same" do
          @game.submit_code([1,3,3,4])
          result = @game.get_pluses
          expect(result).to eq(["+","+","+"])
        end
        it "gets two pluses if two numbers of indices are the same" do
          @game.submit_code([1,5,3,2])
          result = @game.get_pluses
          expect(result).to eq(["+","+"])
        end
        it "gets plus if only one number of indices are the same" do
          @game.submit_code([2,2,2,2])
          result = @game.get_pluses
          expect(result).to eq(["+"])
        end
        it "get an empty array if there are no matches on indeces" do
          @game.submit_code([2,5,2,2])
          result = @game.get_pluses
          expect(result).to eq([])
        end
      end
      describe "a number match:" do
        it "get new array from secret code without numbers that have matchers by values and indeces" do
          @game.submit_code([1,2,6,5])
          @game.get_pluses
          no_plus = @game.instance_variable_get(:@without_plus_sec)
          expect(no_plus).to eq([3,4])
        end
        it "get new array from submit code without numbers that have matchers by values and indeces" do
          @game.submit_code([1,2,6,5])
          @game.get_pluses
          no_plus = @game.instance_variable_get(:@without_plus_sub)
          expect(no_plus).to eq([6,5])
        end
      end
      describe "after get minuses" do
        it "get 4 minuses" do
          @game.submit_code([4,3,2,1])
          @game.get_pluses
          res_minus = @game.get_minuses
          expect(res_minus).to eq(["-","-","-","-"])
        end
        it "get 3 minuses" do
          @game.submit_code([4,1,3,2])
          @game.get_pluses
          res_minus = @game.get_minuses
          expect(res_minus).to eq(["-","-","-"])
        end
        it "get 2 minuses" do
          @game.submit_code([1,3,2,4])
          @game.get_pluses
          res_minus = @game.get_minuses
          expect(res_minus).to eq(["-","-"])
        end
        it "get 2 minus in result" do
          @game.submit_code([3,3,1,1])
          res_minus = @game.get_minuses
          expect(res_minus).to eq(["-","-"])
        end
        it "get 1 minuses" do
          @game.submit_code([5,4,5,6])
          @game.get_pluses
          res_minus = @game.get_minuses
          expect(res_minus).to eq(["-"])
        end
      end
      describe "get the right results in the comparison of the alleged code and secret code" do
        it "get 1 plus in result" do
          @game.submit_code([3,3,3,3])
          result = @game.check_submit_code
          expect(result).to eq(["+"])
        end
        it "get 1 minus in result" do
          @game.submit_code([6,5,1,5])
          result = @game.check_submit_code
          expect(result).to eq(["-"])
        end
        it "get 1 plus and 1 minus in result" do
          @game.submit_code([6,2,1,5])
          result = @game.check_submit_code
          expect(result).to eq(["+","-"])
        end
        it "get 1 plus and 1 minus in result" do
          @game.submit_code([6,2,1,1])
          result = @game.check_submit_code
          expect(result).to eq(["+","-"])
        end
        it "get 2 plus and 1 minus in result" do
          @game.submit_code([6,2,1,4])
          result = @game.check_submit_code
          expect(result).to eq(["+","+","-"])
        end
        #-------------------------------need to write
        #-------------------------------
        #-------------------------------
      end
    end
    
    describe "#Code-breaker wins game" do
      before do
        @game = Codebreaker::Game.new
        @secret_code = @game.start
        @game.submit_code(@secret_code)
        @game.get_pluses
      end
      it "may say you win" do
        expect(@game.win?).to eq(true)
      end
      
    end
    
    describe "#Code-breaker loses game" do
      it "should spend three attempts whith difficalt - hard" do
        @secret_code = @game.start(3)
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
        3.times do 
          @game.submit_code([6,5,4,3])
        end
        attem = @game.instance_variable_get(:@attempts)
        expect(attem).to eq(3)
      end
          it "should spend three attempts whith difficalt - normal" do
        @secret_code = @game.start(2)
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
        3.times do 
            @game.submit_code([6,5,4,3])
          end
      attem = @game.instance_variable_get(:@attempts)
      expect(attem).to eq(7)
          end
      it "should spend three attempts whith difficalt - easy" do
        @secret_code = @game.start
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
        3.times do 
          @game.submit_code([6,5,4,3])
        end
          expect(@game.instance_variable_get(:@attempts)).to eq(12)
          end
      it "may say you lose" do
        @secret_code = @game.start(3)
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
        count = @game.instance_variable_get(:@attempts)
        count.times do
          @game.submit_code([1,2,1,6])
        end
        expect(@game.loss?).to eq(true)
      end
    end
    #------------------
    #------------------
    describe "#Code-breaker plays again" do
    end
    
    describe "#Code-breaker requests hint" do
      before do
        @secret_code = @game.start
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
      end
      it "should give the one number of secret code" do
        hint = @game.get_hint
        expect(hint.is_a? Fixnum).to eq(true)
      end
      it "should give any one of secret code" do
        @game.instance_variable_set(:@secret_code,[1,1,1,1])
        hint = @game.get_hint
        expect(hint).to eq(1)
      end
      it "should give tree of secret code" do
        @game.instance_variable_set(:@secret_code,[3,3,3,3])
        hint = @game.get_hint
        expect(hint).to eq(3)
      end
      it "should give the one number of secret code" do
        @game.instance_variable_set(:@secret_code,[6,6,6,6])
        hint = @game.get_hint
        expect(hint).to eq(6)
      end
      it "don't give the second hint" do
        hint = @game.get_hint
        hint = @game.get_hint
        expect(hint).to eq(nil)
      end
    end
    
    describe "#Code-breaker saves score" do
    end
    
  end
end
