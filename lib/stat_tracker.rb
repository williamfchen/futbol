require 'csv'

require_relative './modules/best_module'

class StatTracker
  attr_reader :data,
              :game_file,
              :team_file,
              :best_team_file

  def initialize(data)
    @data = data
    @game_file ||= CSV.read(data[:games], headers: true, header_converters: :symbol).map(&:to_h)
    @team_file ||= team_hash
    @best_team_file ||= CSV.read(data[:game_teams], headers: true, header_converters: :symbol).map(&:to_hash)
  end

  include Best
  
  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def team_hash
    hash = {}
    CSV.foreach(data[:teams], headers: true, header_converters: :symbol) do |row|
      team_id = row[:team_id]
      team_name = row[:teamname]
      hash[team_id] = team_name
    end
    hash
  end
end