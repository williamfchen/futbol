require_relative '../helper_class'

module Teams
  def count_of_teams
    Team.teams.count
  end  
end