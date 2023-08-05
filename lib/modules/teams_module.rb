require_relative '../team'
require 'pry'

module Teams
  def count_of_teams
    Team.teams.count
  end 
  
  def team_info(team_id)
     {"team_id" => team_id,
        "franchise_id" => select_team_object_with(team_id).franchise_id,
        "team_name" => select_team_object_with(team_id).teamname,
        "abbreviation" => select_team_object_with(team_id).abbreviation,
        "link" => select_team_object_with(team_id).link
      }
  end

  private

  def select_team_object_with(team_id)
    Team.teams.find { |team| team.team_id == team_id}
  end
end