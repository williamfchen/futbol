require_relative '../team'

module Teams
  def count_of_teams
    Team.teams.count
  end  
end