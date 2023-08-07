require_relative 'spec_helper'

RSpec.describe Team do
  let(:team) { Team.new({team_id: "1", 
                        teamname: "Atlanta United",
                        franchiseid: "71",
                        abbreviation: "ATL",
                        link: "1"
                        }) }

  describe '#initialize' do
    it 'exists' do

      expect(team).to be_a Team
    end

    it 'has attributes' do

      expect(team.team_id).to eq("1")
      expect(team.teamname).to eq("Atlanta United")
      expect(team.franchise_id).to eq("71")
      expect(team.abbreviation).to eq("ATL")
      expect(team.link).to eq("1")
    end
  end

  describe "#self.teams" do
    it "collects all team class objects" do
      expect(Team.teams).to all be_a Team
    end
  end

  describe "#self.teams_lookup" do
    it "finds the team name with team id" do
      expect(Team.teams_lookup["1"]).to eq("Atlanta United")
    end
  end
end