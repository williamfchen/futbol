require_relative '../season'
require_relative '../game_team'
require_relative '../season_game_id'
require_relative '../team'

module Seasons
  def total_games_played
    Season.seasons.map { |season| season.game_id }.flatten.count
  end

  def highest_total_score
    away_goals = Season.seasons.map { |season| season.away_goals.map(&:to_i) }.flatten
    home_goals = Season.seasons.map { |season| season.home_goals.map(&:to_i) }.flatten
    totals = [away_goals, home_goals].transpose.map { |each| each.sum }
    totals.max
  end

  def lowest_total_score
    away_goals = Season.seasons.map { |season| season.away_goals.map(&:to_i) }.flatten
    home_goals = Season.seasons.map { |season| season.home_goals.map(&:to_i) }.flatten
    totals = [away_goals, home_goals].transpose.map { |each| each.sum }
    totals.min
  end

  def percentage_home_wins
    home_wins = GameTeam.game_teams.count { |game| game.hoa == "home" && game.result == "WIN" }
    (home_wins.to_f / total_games_played.to_f).round(2)
  end
  
  def percentage_visitor_wins
    away_wins = GameTeam.game_teams.count { |game| game.hoa == "away" && game.result == "WIN" }
    (away_wins.to_f / total_games_played.to_f).round(2)
  end

  def percentage_ties
    ties = GameTeam.game_teams.count { |game| game.result == "TIE" }/2
    (ties.to_f / total_games_played.to_f).round(2)
  end

  def count_of_games_by_season
    Season.seasons.each_with_object({}) { |season, hash| hash[season.season] = season.game_id.count }
  end

  def average_goals_per_game
    away_goals = Season.seasons.map { |season| season.away_goals.map(&:to_i) }.flatten
    home_goals = Season.seasons.map { |season| season.home_goals.map(&:to_i) }.flatten
    totals = [away_goals, home_goals].transpose.sum { |each| each.sum }
    (totals.to_f / total_games_played.to_f).round(2)
  end

  def average_goals_by_season
    Season.seasons.each_with_object({}) do |season, hash| 
      away = season.away_goals.map(&:to_i)
      home = season.home_goals.map(&:to_i)
      total = [away, home].transpose.sum { |each| each.sum }
      hash[season.season] = (total.to_f / season.game_id.count.to_f).round(2)
    end
  end

  def most_tackles(request_season)
    team_hash = all_tackles_in(request_season).max_by {|team, total_tackles| total_tackles}[0]
    Team.teams_lookup[team_hash]
  end
  
  def fewest_tackles(request_season)
    team_hash = all_tackles_in(request_season).min_by {|team, total_tackles| total_tackles}[0]
    Team.teams_lookup[team_hash]
  end

  def most_accurate_team(request_season)
    team_hash = all_accuracies(request_season).max_by {|team, accuracies| accuracies} [0]
    Team.teams_lookup[team_hash]
  end

  def least_accurate_team(request_season)
    team_hash = all_accuracies(request_season).min_by {|team, accuracies| accuracies} [0]
    Team.teams_lookup[team_hash]
  end

  def winningest_coach(request_season)
    coach_win_percentage(request_season).key(coach_win_percentage(request_season).values.max)
  end
  
  def worst_coach(request_season)
    coach_win_percentage(request_season).key(coach_win_percentage(request_season).values.min)
  end
  
  private

  def coach_win_percentage(request_season)
    coach_wins = seasonal_coach_games[request_season].each_with_object({}) { |(key, value), hash| hash[key] = value.count { |game| game.result == "WIN" } }
    coach_total_games = seasonal_coach_games[request_season].each_with_object ({}) { |(key, value), hash| hash[key] = value.count }
    win_percentages = coach_wins.each_with_object({}) {|(key, value), hash| hash[key] = value.to_f / coach_total_games[key].to_f }
  end

  def seasonal_coach_games
    seasonal_game_teams.each_with_object({}) { |(season, game), hash| hash[season] = game.group_by { |each| each.coach } }
  end

  def seasonal_games
    Season.seasons.each_with_object({}) { |season, hash| hash[season.season] = season.game_id }
  end

  def seasonal_game_teams
    seasonal_games.each_with_object({}) { |(key, value), hash| hash[key] =  GameTeam.game_teams.find_all { |game| value.include?(game.game_id) } }
  end

  def all_tackles_in(request_season)
    season_game_teams = GameTeam.game_teams.select { |game| game_id_season(request_season).include?(game.game_id) }
    only_team_id = season_game_teams.map { |team| team.team_id }.uniq
    
    all_tackles = Hash.new(0)
    
    season_game_teams.each do |teams|
      if only_team_id.include?(teams.team_id)
        all_tackles[teams.team_id] += teams.tackles.to_i
      end
    end
    all_tackles
  end 

  def all_accuracies(request_season)
    season_game_teams = GameTeam.game_teams.select { |game| game_id_season(request_season).include?(game.game_id) }
    only_team_id = season_game_teams.map { |team| team.team_id }.uniq
    
    all_goals = Hash.new(0)
    all_shots = Hash.new(0)

    season_game_teams.each do |teams|
      if only_team_id.include?(teams.team_id)
        all_goals[teams.team_id] += teams.goals.to_i
        all_shots[teams.team_id] += teams.shots.to_i
      end
    end
    all_accuracies = all_goals.merge(all_shots) {|team_id, old_data, new_data| old_data.to_f / new_data.to_f }
  end 
  
  def game_id_season(request_season)
    the_season = SeasonGameID.games.select { |game| game.season == request_season }
    the_season.map { |game| game.game_id }
  end




end