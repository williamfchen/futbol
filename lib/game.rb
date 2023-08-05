class Game
  @@games = []
  @@season_lookup = {}

  attr_reader :season,
              :game_id,
              :away_team_id,
              :away_team_goals,
              :home_team_id,
              :home_team_goals

  def initialize(test_game_file)
    @season = test_game_file[:season]
    @game_id = test_game_file[:game_id]
    @away_team_id = test_game_file[:away_team_id]
    @away_team_goals = test_game_file[:away_goals].to_i
    @home_team_id = test_game_file[:home_team_id]
    @home_team_goals = test_game_file[:home_goals].to_i
    @@games << self
    @@season_lookup[@season] ||= []
    @@season_lookup[@season] << @game_id
  end

  def self.games
    @@games
  end

  def self.season_lookup
    @@season_lookup
  end
end