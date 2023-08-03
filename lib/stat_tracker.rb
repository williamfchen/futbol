require_relative 'helper_class'

class StatTracker
  attr_reader :data, 
              :team_file,
              :game_file,
              :game_team_file,
              :test_game_file

  def initialize(data)
    @data = data
    @game_file ||= CSV.open(data[:games], headers: true, header_converters: :symbol).group_by { |row| row[:season] }.map {|key, value| Season.new(key, value)}
    @game_file ||= CSV.open(data[:games], headers: true, header_converters: :symbol).group_by { |row| row[:season] }.map {|key, value| Season.new(key, value)}
    @team_file ||= CSV.foreach(data[:teams], headers: true, header_converters: :symbol) { |row| Team.new(row) }
    # @test_game_file ||= CSV.foreach(data[:games], headers: true, header_converters: :symbol).take(20).map { |row| TeamPerformance.new(row) }
    @game_team_file ||= CSV.foreach(data[:game_teams], headers: true, header_converters: :symbol) { |row| GameTeam.new(row) }
    @teams_lookup = {}
    CSV.foreach(data[:teams], headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
      @teams_lookup[team.team_id] = team.teamname
    end
    @test_game_file ||= CSV.foreach(data[:games], headers: true, header_converters: :symbol).map do |row|
      team_performance_data = row.to_h
      team_performance_data[:home_team_name] = @teams_lookup[team_performance_data[:home_team_id]]
      team_performance_data[:away_team_name] = @teams_lookup[team_performance_data[:away_team_id]]
      TeamPerformance.new(team_performance_data)
    end
    # require 'pry'; binding.pry
  end

  include Teams
  include Games
  include Seasons
  
  def rewind(file)
    file.rewind
  end
  
  def self.from_csv(locations)
    StatTracker.new(locations)
  end
  
  def create_seasons
    season_finder.each do |season|
      season_id = season
      game_count = count_of_games_by_season(season)
      games_played = seasonal_game_collector(season)
      avg_goals = average_goals_per_game(season)
      # winningest_coach = winningest_coach(season)
      @seasons << Season.new(season, count_of_games_by_season(season), seasonal_game_collector(season), average_goals_per_game(season))
    end
  end

  def create_games
    @game_file.each do |game|
      @games << Game.new(game, @team_file)
    end
  end

  def create_game_team
    @game_team_file.each do |game_team|
      @game_teams << Game.new(game_team, @team_file)
    end
  end

  
  def season_finder
    all_seasons = @game_file.map { |row| row[:season] }.uniq
    rewind(@game_file)
    all_seasons
  end
  
  def count_of_games_by_season(season)
    game_count = @game_file.count { |game| game[:season] == season }
    rewind(@game_file)
    game_count
  end

  def seasonal_game_collector(season)
    seasonal = @game_file.find_all { |game| game[:season] == season }
    rewind(@game_file)
    seasonal.flat_map { |row| row[:game_id] }
  end

  def average_goals_per_game(season)
    total_goals = @game_file.sum { |game| game[:away_goals] + game[:home_goals] }
    rewind(@game_file) 
    total_goals / count_of_games_by_season(season)
  end

  # def winningest_coach(season)
  #   @game_team_file.max_by { |row|}

end