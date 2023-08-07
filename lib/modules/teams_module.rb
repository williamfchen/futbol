require_relative '../team'
require_relative 'seasons_module'
require 'pry'

module Teams
  include Seasons

  def count_of_teams
    Team.teams.count
  end 
  
  def team_info(team_id)
     {"team_id" => team_id,
        "franchise_id" => find_team_object_with(team_id).franchise_id,
        "team_name" => find_team_object_with(team_id).teamname,
        "abbreviation" => find_team_object_with(team_id).abbreviation,
        "link" => find_team_object_with(team_id).link
      }
  end
  
  def best_season(team_id)
    season_percentages(team_id).max_by { |season, percent| percent}.first
  end
  
  def worst_season(team_id)
    season_percentages(team_id).min_by { |season, percent| percent}.first
  end
  
  private

  def season_percentages(team_id)
    wins = game_id_for_wins(team_id)
    losses = game_id_for_losses(team_id)
    Game.games.group_by { |game| game.season }.each_with_object({}) do |(season, game), hash|
      win_count = game.count {|game| wins.include?(game.game_id)}
      loss_count = game.count {|game| losses.include?(game.game_id)}
      hash[season] = win_count / (win_count + loss_count).to_f
    end
  end

  def find_team_object_with(team_id)
    Team.teams.find { |team| team.team_id == team_id}
  end

  def select_team_object_with(team_id)
    GameTeam.game_teams.select { |team| team.team_id == team_id }
  end

  def game_id_for_wins(team_id)
    select_team_object_with(team_id).filter_map { |game| game.game_id if game.result == "WIN" }
  end

  def game_id_for_losses(team_id)
    select_team_object_with(team_id).filter_map { |game| game.game_id if game.result == "LOSS" }
  end
end