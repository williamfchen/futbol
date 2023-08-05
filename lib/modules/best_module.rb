require_relative '../team'

module Best
  def count_of_teams
    Team.teams.count
  end  

  def winningest_coach(season)
    coach_win_percentage(season).max_by { |_, values| values[:wins].to_f / values[:games] }[0]
  end
  
  def worst_coach(season)
    coach_win_percentage(season).min_by { |_, values| values[:wins].to_f / values[:games] }[0]
  end
  
  def most_accurate_team(season)
    id = team_accuracy(season).max_by { |_, accuracy| accuracy[:goals].to_f / accuracy[:shots] }[0] 
    Team.teams_lookup[id]
  end
  
  def least_accurate_team(season)
    id = team_accuracy(season).min_by { |_, accuracy| accuracy[:goals].to_f / accuracy[:shots] }[0]
    Team.teams_lookup[id]
  end

  def most_tackles(season)
    id = team_accuracy(season).max_by { |_, accuracy| accuracy[:tackles] }[0] 
    Team.teams_lookup[id]
  end

  def fewest_tackles(season)
    id = team_accuracy(season).min_by { |_, accuracy| accuracy[:tackles] }[0] 
    Team.teams_lookup[id]
  end

  def best_offense
    id = team_stats.max_by { |team, value_hash| value_hash[:total_goals].to_f / value_hash[:total_games] }.first
    Team.teams_lookup[id]
  end

  def worst_offense
    id = team_stats.min_by { |team, value_hash| value_hash[:total_goals].to_f / value_hash[:total_games] }.first
    Team.teams_lookup[id]
  end

  def highest_scoring_home_team
    id = team_stats.max_by { |team, value_hash| value_hash[:home_goals].to_f / value_hash[:home_games] }.first
    Team.teams_lookup[id]
  end
  
  def lowest_scoring_home_team
    id = team_stats.min_by { |team, value_hash| value_hash[:home_goals].to_f / value_hash[:home_games] }.first
    Team.teams_lookup[id]
  end

  def highest_scoring_visitor
    id = team_stats.max_by { |team, value_hash| value_hash[:away_goals].to_f / value_hash[:away_games] }.first
    Team.teams_lookup[id]
  end
  
  def lowest_scoring_visitor
    id = team_stats.min_by { |team, value_hash| value_hash[:away_goals].to_f / value_hash[:away_games] }.first
    Team.teams_lookup[id]
  end

  def total_games_played
    game_file.count
  end

  def highest_total_score
    highest_scoring_game = game_file.max_by { |game| game[:home_goals].to_i + game[:away_goals].to_i }
    highest_scoring_game[:home_goals].to_i + highest_scoring_game[:away_goals].to_i
  end

  def lowest_total_score
    lowest_scoring_game = game_file.min_by { |game| game[:home_goals].to_i + game[:away_goals].to_i }
    lowest_scoring_game[:home_goals].to_i + lowest_scoring_game[:away_goals].to_i
  end
  
  def count_of_games_by_season
    game_file.group_by { |game| game[:season] }.each_with_object({}) { |(season, game), hash| hash[season] = game.count }
  end

  def average_goals_per_game
    total_goals = 0
    game_file.each do |game|
      total_goals += game[:away_goals].to_i + game[:home_goals].to_i
    end
    (total_goals.to_f / total_games_played).round(2)
  end

  def average_goals_by_season
    game_file.group_by { |game| game[:season] }.each_with_object({}) do |(season, game), hash| 
      away = game.map { |each| each[:away_goals].to_i }
      home = game.map { |each| each[:home_goals].to_i }
      total = [away, home].transpose.sum { |each| each.sum }
      hash[season] = (total.to_f / game.count.to_f).round(2)
    end
  end

  def percentage_home_wins
    home_wins = best_team_file.count { |game| game[:hoa] == "home" && game[:result] == "WIN" }
    (home_wins.to_f / total_games_played).round(2)
  end
  
  def percentage_visitor_wins
    away_wins = best_team_file.count { |game| game[:hoa] == "away" && game[:result] == "WIN" }
    (away_wins.to_f / total_games_played).round(2)
  end

  def percentage_ties
    ties = best_team_file.count { |game| game[:result] == "TIE" }.to_f
    ((ties / 2) / total_games_played).round(2)
  end

  private

  def coach_win_percentage(season)
    season_data = best_team_file.select { |game| game[:game_id].start_with?(season[0, 4]) }
    coach_win_percentage = Hash.new { |h, k| h[k] = { wins: 0, games: 0 } }
    season_data.each do |game|
      coach = game[:head_coach]
      result = game[:result]
      coach_win_percentage[coach][:wins] += 1 if result == 'WIN'
      coach_win_percentage[coach][:games] += 1
    end
    coach_win_percentage
  end

  def team_accuracy(season)
    season_data = best_team_file.select { |game| game[:game_id].start_with?(season[0, 4]) }
    team_accuracy = Hash.new { |h, k| h[k] = { shots: 0, goals: 0, tackles: 0 } }
    season_data.each do |game|
      team_id = game[:team_id]
      team_accuracy[team_id][:shots] += game[:shots].to_i
      team_accuracy[team_id][:goals] += game[:goals].to_i
      team_accuracy[team_id][:tackles] += game[:tackles].to_i
    end
    team_accuracy
  end

  def team_stats
    team_stats = Hash.new { |h, k| h[k] = { home_goals: 0, away_goals: 0, total_goals: 0, home_games: 0, away_games: 0, total_games: 0 } }
    game_file.each do |game|
      away_team_id = game[:away_team_id]
      home_team_id = game[:home_team_id]
      away_goals = game[:away_goals].to_i
      home_goals = game[:home_goals].to_i
    
      # Update away team stats
      team_stats[away_team_id][:away_goals] += away_goals
      team_stats[away_team_id][:total_goals] += away_goals
      team_stats[away_team_id][:away_games] += 1
      team_stats[away_team_id][:total_games] += 1
    
      # Update home team stats
      team_stats[home_team_id][:home_goals] += home_goals
      team_stats[home_team_id][:total_goals] += home_goals
      team_stats[home_team_id][:home_games] += 1
      team_stats[home_team_id][:total_games] += 1
    end
    team_stats
  end

end

  