require 'csv'
require_relative 'team'
require_relative 'game_team'
require_relative 'game'
require_relative './modules/teams_module'
require_relative './modules/seasons_module'
require_relative './modules/games_module'

class StatTracker
  attr_reader :data,
              :game_file,
              :team_file,
              :game_team_file

  def initialize(data)
    @data = data
    @game_file ||= CSV.foreach(data[:games], headers: true, header_converters: :symbol) { |row| Game.new(row) }
    @team_file ||= CSV.foreach(data[:teams], headers: true, header_converters: :symbol) { |row| Team.new(row) }
    @game_team_file ||= CSV.foreach(data[:game_teams], headers: true, header_converters: :symbol) { |row| GameTeam.new(row) }
  end

  include Teams
  include Games
  include Seasons
  
  def self.from_csv(locations)
    StatTracker.new(locations)
  end

end