class Team
  @@teams = []
  @@teams_lookup = {}

  attr_reader :teamname,
              :team_id,
              :franchise_id,
              :abbreviation,
              :link

  def initialize(team_details)
    @teamname = team_details[:teamname]
    @team_id = team_details[:team_id]
    @franchise_id = team_details[:franchiseid]
    @abbreviation = team_details[:abbreviation]
    @link = team_details[:link]
    @@teams << self
    @@teams_lookup[@team_id] = @teamname
  end

  def self.teams
    @@teams
  end

  def self.teams_lookup
    @@teams_lookup
  end
end
