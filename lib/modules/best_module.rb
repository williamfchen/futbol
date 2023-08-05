require_relative '../season'
require_relative '../game_team'
require_relative '../game'
require_relative '../team'
require_relative '../stat_tracker'

module Best
  def winningest_coach(request_season)
    season_data = best_team_file.select { |game| game[:game_id].start_with?(request_season) }
    require 'pry';binding.pry
    coach_win_percentage = Hash.new { |h, k| h[k] = [0, 0] }
  
    season_data.each do |game|
      coach = game['head_coach']
      result = game['result']
      if result == 'WIN'
        coach_win_percentage[coach][0] += 1
      end
      coach_win_percentage[coach][1] += 1
    end
    winningest_coach = coach_win_percentage.max_by { |_coach, (wins, total)| wins.to_f / total }[0]
  end
end
