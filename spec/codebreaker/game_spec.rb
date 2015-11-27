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
        expect(@secret_code).to all(satisfy{|el| el>=1 && el<=6})
      end
      it "should not set the level of difficulty" do
        expect{@game.start("asd3")}.to raise_error(TypeError)
      end
      it "should not set the level of difficulty" do
        @game.start("1asd3")
        expect(@game.instance_variable_get(:@value)).to eq(1)
      end
      it "should set the level of difficulty" do
        @game.start("3try2")
        expect(@game.instance_variable_get(:@value)).to eq(3)
      end
      it "should set the level of difficulty" do
        expect(@game.instance_variable_get(:@value)).to eq(3)
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
      it "should lose one attempt" do
        expect{@game.submit_code([1,2,3,3])}.to change{@game.instance_variable_get(:@attempts)}.by(-1)
      end
      it "return error if the guess has only three digits" do
        expect{@game.submit_code([1,1,1])}.to raise_error(ArgumentError) 
      end
      describe "an exact match:" do
        it "gets four pluses if four numbers of indices are the same" do
          @game.submit_code([1,2,3,4])
          result = @game.check_submit_code
          expect(result).to eq(["+","+","+","+"])
        end
        it "gets three pluses if three numbers of indices are the same" do
          @game.submit_code([1,3,3,4])
          result = @game.check_submit_code
          expect(result).to eq(["+","+","+"])
        end
        it "gets two pluses if two numbers of indices are the same and one minus" do
          @game.submit_code([1,5,3,2])
          result = @game.check_submit_code
          expect(result).to eq(["+","+","-"])
        end
        it "gets plus if only one number of indices are the same" do
          @game.submit_code([2,2,2,2])
          result = @game.check_submit_code
          expect(result).to eq(["+"])
        end
        it "get an empty array if there are no matches on indeces" do
          @game.submit_code([6,6,6,6])
          result = @game.check_submit_code
          expect(result).to eq([])
        end
      end
      describe "a number match:" do
        it "get new array from secret code without numbers that have matchers by values and indeces" do
          @game.submit_code([1,2,6,5])
          @game.check_submit_code
          no_plus = @game.instance_variable_get(:@without_plus_sec)
          expect(no_plus).to eq([3,4])
        end
        it "get new array from submit code without numbers that have matchers by values and indeces" do
          @game.submit_code([1,2,6,5])
          @game.check_submit_code
          no_plus = @game.instance_variable_get(:@without_plus_sub)
          expect(no_plus).to eq([6,5])
        end
      end
      describe "after get minuses" do
        
        
      it "get 4 numbers from user" do
        @game.instance_variable_set(:@secret_code,[3,4,4,4])
        @submit_code = @game.submit_code([4,3,3,3])
        res = @game.check_submit_code
        expect(res).to eq(["-","-"])
      end
      
        it "get 2 minuses" do
          @game.submit_code([1,3,2,4])
          res = @game.check_submit_code
          expect(res).to eq(["+","+","-"])
        end
        it "get 2 minus in result" do
          @game.submit_code([3,3,1,1])
          res = @game.check_submit_code
          expect(res).to eq(["-","-"])
        end
        it "get 1 minuses" do
          @game.submit_code([5,4,5,6])
          res = @game.check_submit_code
          expect(res).to eq(["-"])
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
        it "get 2 plus and 1 minus in result" do
          @game.instance_variable_set(:@secret_code,[2,4,4,2])
          @game.submit_code([1,2,3,4])
          result = @game.check_submit_code
          expect(result).to eq(["-","-"])
        end

      end
    end
    
    describe "#Code-breaker wins game" do
      before do
        @game.submit_code(@secret_code)
        @game.check_submit_code
      end
      it "may say you win" do
        expect(@game.respond_to?(:win?)).to be_truthy
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
          @game.instance_variable_set(:@attempts, 0)
        expect(@game.loss?).to be_truthy
      end
    end
  
    describe "#Code-breaker requests hint" do
      before (:each) do
        @secret_code = @game.start
        @game.instance_variable_set(:@secret_code,[1,2,3,4])
      end
      it "should give the one number of secret code" do
        hint = @game.get_hint
        expect(hint).to be_a(Fixnum)
      end
      it "should give any one of secret code" do
        @game.instance_variable_set(:@secret_code,[1,1,1,1])
        hint = @game.get_hint
        expect(hint).to eq(1)
      end
      it "secret code should include a hint" do
        hint = @game.get_hint
        expect(@game.instance_variable_get(:@secret_code)).to include(hint)
      end
      it "don't give the second hint" do
        hint = @game.get_hint
        hint = @game.get_hint
        expect(hint).to be(nil)
      end
    end
  end
end
