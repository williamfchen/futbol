require_relative 'spec_helper'

RSpec.describe StatTracker do
  let(:data) do
    {
      games: './data/games.csv',
      teams: './data/teams.csv',
      game_teams: './data/game_teams.csv'
    }
  end
  let(:stat_tracker) { StatTracker.from_csv(data) }

  before(:each) do
    GameTeam.class_variable_set :@@game_teams, []
    Team.class_variable_set :@@teams, []
    Game.class_variable_set :@@games, []
  end

  describe '#initialize' do
    it 'should initialize with the correct instance variables' do
      expect(stat_tracker).to be_a StatTracker
      expect(stat_tracker.data).to eq(data)
    end
  end
  
  describe '#count_of_teams' do
    it 'counts the total number of teams' do
      expect(stat_tracker.count_of_teams).to eq 32
    end
  end

  describe "#highest_total_score" do
    it 'returns the highest total score in a game through all seasons' do

      expect(stat_tracker.highest_total_score).to eq(11)
    end
  end

  describe "#loweest_total_score" do
    it 'returns the lowest total score in a game through all seasons' do

      expect(stat_tracker.lowest_total_score).to eq(0)
    end
  end

  describe "#total_games_played" do
    it 'returns the total number of games played across all seasons' do

      expect(stat_tracker.total_games_played).to eq(7441)
    end
  end

  describe "#percentage_home_wins" do
    it 'returns the percentage of games that a home team won, to the nearest hundreth' do

      expect(stat_tracker.percentage_home_wins).to eq(0.44)
    end
  end

  describe "#percentage_visitor_wins" do
    it 'returns the percentage of games that a visiting team won, to the nearest hundreth' do

      expect(stat_tracker.percentage_visitor_wins).to eq(0.36)
    end
  end

  describe "#percentage_ties" do
    it 'returns the percentage of games that ended in a tie, to the nearest hundreth' do

      expect(stat_tracker.percentage_ties).to eq(0.2)
    end
  end

  describe "#count_of_games_by_season" do
    it 'returns a hash with each season and its game count' do
      expectation = {
        "20122013"=>806, 
        "20162017"=>1317, 
        "20142015"=>1319, 
        "20152016"=>1321, 
        "20132014"=>1323, 
        "20172018"=>1355
      }

      expect(stat_tracker.count_of_games_by_season).to be_a Hash
      expect(stat_tracker.count_of_games_by_season).to eq(expectation)
    end
  end
  
  describe "#average_goals_per_game" do
    it 'returns the average goals made per game across all seasons' do
      
      expect(stat_tracker.average_goals_per_game).to eq(4.22)
    end
  end

  describe "#average_goals_by_season" do
    it 'returns a hash with the average goals made per game by season' do
      expectation = {
        "20122013"=>4.12, 
        "20162017"=>4.23, 
        "20142015"=>4.14, 
        "20152016"=>4.16, 
        "20132014"=>4.19, 
        "20172018"=>4.44
      }

      expect(stat_tracker.average_goals_by_season).to be_a Hash
      expect(stat_tracker.average_goals_by_season).to eq(expectation)
    end
  end

  describe "#winningest_coach" do
    it 'returns the name of the coach with the highest win percentage for that season' do

      expect(stat_tracker.winningest_coach("20122013")).to eq("Dan Lacroix")
      expect(stat_tracker.winningest_coach("20132014")).to eq("Claude Julien")
      expect(stat_tracker.winningest_coach("20142015")).to eq("Alain Vigneault")
      expect(stat_tracker.winningest_coach("20152016")).to eq("Barry Trotz")
      expect(stat_tracker.winningest_coach("20162017")).to eq("Bruce Cassidy")
      expect(stat_tracker.winningest_coach("20172018")).to eq("Bruce Cassidy")
    end
  end

  describe "#worst_coach" do
    it 'returns the name of the coach with the highest win percentage for that season' do

      expect(stat_tracker.worst_coach("20122013")).to eq("Martin Raymond")
      expect(stat_tracker.worst_coach("20132014")).to eq("Peter Laviolette")
      expect(stat_tracker.worst_coach("20142015")).to eq("Ted Nolan")
      expect(stat_tracker.worst_coach("20152016")).to eq("Todd Richards")
      expect(stat_tracker.worst_coach("20162017")).to eq("Dave Tippett")
      expect(stat_tracker.worst_coach("20172018")).to eq("Phil Housley")
    end
  end

  describe "#most_tackles" do
    it "can print the name of the team with the most tackles by season" do

      expect(stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
      expect(stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
    end
  end

  describe "#fewest_tackles" do 
    it "can print the name of the team with the fewest tackles by season" do

      expect(stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
      expect(stat_tracker.fewest_tackles("20142015")).to eq "Orlando City SC"
    end
  end
  
  describe '#best_offense' do
    it 'returns the team with the most average goals scored' do

      expect(stat_tracker.best_offense).to eq "Reign FC"
    end
  end

  describe '#worst_offense' do
    it 'returns the team with the least average goals scored' do

      expect(stat_tracker.worst_offense).to eq "Utah Royals FC"
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns the home team with the highest average score per game' do

      expect(stat_tracker.highest_scoring_home_team).to eq "Reign FC"
    end
  end
  
  describe '#lowest_scoring_home_team' do
    it 'returns the home team with the lowest average score per game' do

      expect(stat_tracker.lowest_scoring_home_team).to eq "Utah Royals FC"
    end
  end

  describe '#highest_scoring_visitor' do
    it 'returns the visitor with the highest average score per game' do

      expect(stat_tracker.highest_scoring_visitor).to eq "FC Dallas"
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'returns the visitor with the lowest average score per game' do

      expect(stat_tracker.lowest_scoring_visitor).to eq "San Jose Earthquakes"
    end
  end

  describe "#most_accurate_team" do
    it "can print the name of the team with the highest accuracy by season" do

      expect(stat_tracker.most_accurate_team("20132014")).to eq "Real Salt Lake"
      expect(stat_tracker.most_accurate_team("20142015")).to eq "Toronto FC"
    end
  end

  describe "#least_accurate_team" do
    it "can print the name of the team with the highest accuracy by season" do

      expect(stat_tracker.least_accurate_team("20132014")).to eq "New York City FC"
      expect(stat_tracker.least_accurate_team("20142015")).to eq "Columbus Crew SC"
    end
  end

  describe "#team_info" do
    it "creates a hash of data for a team given the team " do
      expected = {
        "team_id" => "18",
        "franchise_id" => "34",
        "team_name" => "Minnesota United FC",
        "abbreviation" => "MIN",
        "link" => "/api/v1/teams/18"
      }

      expect(stat_tracker.team_info("18")).to eq expected
    end
  end

  describe "#best_season" do
    it "finds the best season by team id number" do

      expect(stat_tracker.best_season("6")).to eq "20132014"
    end
  end

  describe "#worst_season" do
    it "finds the best season by team id number" do

      expect(stat_tracker.worst_season("6")).to eq "20142015"
    end
  end
end