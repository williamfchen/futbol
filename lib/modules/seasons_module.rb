require_relative '../game_team'
require_relative '../game'
require_relative '../team'

module Seasons
  def total_games_played
    Game.games.count
  end

  def highest_total_score
    Game.games.map { |game| game.away_team_goals + game.home_team_goals }.max
  end

  def lowest_total_score
    Game.games.map { |game| game.away_team_goals + game.home_team_goals }.min
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
    seasons = Game.games.group_by { |game| game.season }.each_with_object({}) { |(season, game), hash| hash[season] = game.count }
  end

  def average_goals_per_game
    totals = Game.games.map { |game| game.away_team_goals + game.home_team_goals }
    (totals.sum.to_f / totals.count.to_f).round(2)
  end

  def average_goals_by_season
    Game.games.group_by { |game| game.season }.each_with_object({}) do |(season, game), hash| 
      away = game.map { |each| each.away_team_goals.to_i }
      home = game.map { |each| each.home_team_goals.to_i }
      total = [away, home].transpose.sum { |each| each.sum }
      hash[season] = (total.to_f / game.count.to_f).round(2)
    end
  end

  def most_tackles(request_season)
    Team.teams_lookup[all_tackles_in(request_season).key(all_tackles_in(request_season).values.max)]
  end
  
  def fewest_tackles(request_season)
    Team.teams_lookup[all_tackles_in(request_season).key(all_tackles_in(request_season).values.min)]
  end

  def most_accurate_team(request_season)
    Team.teams_lookup[all_accuracies(request_season).key(all_accuracies(request_season).values.max)]
  end

  def least_accurate_team(request_season)
    Team.teams_lookup[all_accuracies(request_season).key(all_accuracies(request_season).values.min)]
  end

  def winningest_coach(request_season)
    coach_win_percentage(request_season).key(coach_win_percentage(request_season).values.max)
  end
  
  def worst_coach(request_season)
    coach_win_percentage(request_season).key(coach_win_percentage(request_season).values.min)
  end
  
  private

  def coach_win_percentage(request_season)
    game_id_by_season = game_id_season(request_season)
    gameteam_by_season = game_team_season(game_id_by_season)
    seasonal_coach_games = gameteam_by_season.group_by { |each| each.coach }
    coach_wins = seasonal_coach_games.each_with_object({}) { |(key, value), hash| hash[key] = value.count { |game| game.result == "WIN" } }
    coach_total_games = seasonal_coach_games.each_with_object ({}) { |(key, value), hash| hash[key] = value.count }
    win_percentages = coach_wins.each_with_object({}) {|(key, value), hash| hash[key] = value.to_f / coach_total_games[key].to_f }
  end

  def all_tackles_in(request_season)
    game_id_by_season = game_id_season(request_season)
    gameteam_by_season = game_team_season(game_id_by_season)
    gameteam_by_season.each_with_object(Hash.new(0)) { |game, hash| hash[game.team_id] += game.tackles.to_i }
  end 

  def all_accuracies(request_season)
    game_id_by_season = game_id_season(request_season)
    gameteam_by_season = game_team_season(game_id_by_season)
    all_shots = gameteam_by_season.each_with_object(Hash.new(0)) { |game, hash| hash[game.team_id] += game.shots.to_i }
    all_goals = gameteam_by_season.each_with_object(Hash.new(0)) { |game, hash| hash[game.team_id] += game.goals.to_i }
    all_accuracies = all_goals.merge(all_shots) {|team_id, old_data, new_data| old_data.to_f / new_data.to_f }
  end 
  
  def game_id_season(request_season)
    each_season ||= Game.games.group_by { |game| game.season }
    each_season[request_season].map { |game| game.game_id }
  end

  def game_team_season(games)
    each_season = GameTeam.game_teams.select { |game| game.team_id if games.include?(game.game_id) }
  end  
end