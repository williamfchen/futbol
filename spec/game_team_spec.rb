require_relative 'spec_helper'

describe GameTeam do
  let (:gameteam1) {gameteam1 = GameTeam.new({ game_id: 123456, 
                                          hoa: "HOME",
                                          team_id: 7337,
                                          result: "WIN",
                                          head_coach: "Hank Hill",
                                          goals: 2, 
                                          tackles: 11,
                                          shots: 77
                                          })}

  describe "set-up" do
    it "exists" do
      expect(gameteam1).to be_a GameTeam
    end

    it "has attributes" do
      expect(gameteam1.game_id).to eq(123456)
      expect(gameteam1.team_id).to eq(7337)
      expect(gameteam1.hoa).to eq("HOME")
      expect(gameteam1.result).to eq("WIN")
      expect(gameteam1.coach).to eq("Hank Hill")
      expect(gameteam1.goals).to eq(2)
      expect(gameteam1.shots).to eq(77)
      expect(gameteam1.tackles).to eq(11)
    end

    it "collects all game team class objects" do
      expect(GameTeam.game_teams).to all be_a GameTeam
    end
  end
end