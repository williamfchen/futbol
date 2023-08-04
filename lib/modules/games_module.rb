require_relative '../game'
require_relative '../team'

module Games
  def best_offense
    id = team_hash.max_by { |team, value_hash| value_hash[:total_goals].to_f / value_hash[:total_games] }.first
    Team.teams_lookup[id]
  end
  
  def worst_offense
    id = team_hash.min_by { |team, value_hash| value_hash[:total_goals].to_f / value_hash[:total_games] }.first
    Team.teams_lookup[id]
  end
  
  def highest_scoring_home_team
    id = team_hash.max_by { |team, value_hash| value_hash[:home_goals].to_f / value_hash[:home_games] }.first
    Team.teams_lookup[id]
  end
  
  def lowest_scoring_home_team
    id = team_hash.min_by { |team, value_hash| value_hash[:home_goals].to_f / value_hash[:home_games] }.first
    Team.teams_lookup[id]
  end
  
  def highest_scoring_visitor
    id = team_hash.max_by { |team, value_hash| value_hash[:away_goals].to_f / value_hash[:away_games] }.first
    Team.teams_lookup[id]
  end
  
  def lowest_scoring_visitor
    id = team_hash.min_by { |team, value_hash| value_hash[:away_goals].to_f / value_hash[:away_games] }.first
    Team.teams_lookup[id]

  end

  private

  def home_goals_by_team
    grouped_home_teams = Game.games.group_by(&:home_team_id)
    grouped_home_teams.transform_values { |game| game.sum(&:home_team_goals) }
  end
  
  def away_goals_by_team
    grouped_away_teams = Game.games.group_by(&:away_team_id)
    grouped_away_teams.transform_values { |game| game.sum(&:away_team_goals) }
  end
    
  def home_games_per_team
    Game.games.group_by(&:home_team_id).transform_values(&:count)
  end
  
  def away_games_per_team
    Game.games.group_by(&:away_team_id).transform_values(&:count)
  end
  
  def team_hash
    team_hash = {}
    home_goals_by_team.each do |team_id, home_goals|
      team_hash[team_id] = {
        home_goals: home_goals,
        away_goals: away_goals_by_team[team_id],
        total_goals: home_goals + away_goals_by_team[team_id],
        home_games: home_games_per_team[team_id],
        away_games: away_games_per_team[team_id],
        total_games: home_games_per_team[team_id] + away_games_per_team[team_id]
      }
    end
    team_hash
  end
end