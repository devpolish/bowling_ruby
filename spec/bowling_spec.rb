require_relative '../bowling'
require 'spec_helper'

describe "bowling" do
  before do
    @game = Game.new "Darth"
    @player = @game.players.first
    @bowls = [10,10,4,2]
  end
  
  context "bonus scores" do
    context "strike" do
      before do
        play @bowls
        @frame = @player.frames.first
      end
      it "should record a strike when 10 pins fall in one bowl" do
        expect(@frame.strike?).to be true
      end
      
      it "should add bonus to score when player bowls a strike" do
        expect(@player.score).to eql 46
      end
    end
    
    context "spare" do
      before do
        @bowls = [4,6,5,4]
        play @bowls
        @frame = @player.frames.first
      end
      it "should record a spare when 10 pins fall in two bowls" do
        expect(@frame.spare?).to be true
      end
      
      it "should add bonus to score when player bowls a spare" do
        expect(@player.score).to eql 24
      end
    end
  end
  
  context "finished game" do
    it "returns 0 for all gutter game" do
      10.times { play [0,0] }
      expect(@player.score).to eql 0
      expect(@game.finished?).to be true
    end
    
    it "returns 300 for perfect game" do
      6.times { play [10,10] }
      expect(@player.score).to eql 300
      expect(@game.finished?).to be true
    end
    
    context "final bonus frame" do
      it "should have a maximum of three bowls if all strikes" do
        12.times { play [10] }
        expect(@player.frames.last.bowls.size).to eql 3
        expect(@player.frames.last.extra_bowls).to eql 2
      end
      
      it "should have 3 bowls if a spare is scored" do
        9.times { play [10] }
        play [5,5,4]
        expect(@player.frames.last.bowls.size).to eql 3
        expect(@player.frames.last.extra_bowls).to eql 1
      end
      
      it "should not offer extra bowls without a bonus bowl" do
        9.times { play [0,0] }
        play [5,4]
        expect(@game.finished?).to be true
        expect(@player.frames.last.extra_bowls).to eql 0
      end
    end
  end
  
  it "calculates scores only from finished frames" do
    play [5]
    expect(@player.frames.last.finished?).to be false
    expect(@player.score).to eql 0
  end
  
  context "with multiple players" do
    before do
      @game = Game.new "Luke", "Leia"
    end
    it "should switch between players" do
      expect(@game.players.size).to eql 2
      expect(@game.current_player.name).to eql "Luke"
      play [6,3]
      expect(@game.current_player.name).to eql "Leia"
    end
    
    it "should keep track of different player's scores" do
      luke = @game.players.first
      leia = @game.players.last
      
      play [5,4]
      expect(luke.score).to be 9
      
      play [1,5]
      expect(leia.score).to be 6
    end
  end
end