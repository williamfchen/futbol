require_relative 'spec_helper'

describe Game do
  let (:game1) {game1 = Game.new({  game_id: "123456", 
                                    season: "20122013",
                                    away_team_id: "3",
                                    home_team_id: "6",
                                    away_goals: "3", 
                                    home_goals: "1", 
                                    })}

  describe "set-up" do
    it "exists" do
      expect(game1).to be_a Game
    end

    it "has attributes" do
      expect(game1.game_id).to eq("123456")
      expect(game1.season).to eq("20122013")
      expect(game1.away_team_id).to eq("3")
      expect(game1.home_team_id).to eq("6")
      expect(game1.away_team_goals).to eq(3)
      expect(game1.home_team_goals).to eq(1)
    end

    it "collects all game class objects" do
      expect(Game.games).to all be_a Game
    end
  end
end