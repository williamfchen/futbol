require './spec/spec_helper'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

puts ""
puts "Welcome to Robert's, Will's, and Joop's futboooooooooool project!" 
sleep(0.8)
puts ""
print "The highest scoring game was #{stat_tracker.highest_total_score} points "  +
"while the lowest scoring game had #{stat_tracker.lowest_total_score} points. \n" +
"Across all seasons home teams won #{stat_tracker.percentage_home_wins * 100}% of games " +
"and away teams won #{stat_tracker.percentage_visitor_wins * 100}%. " +
"#{stat_tracker.percentage_ties * 100}% of games ended in a tie."
puts ""
puts ""

print "This league contains #{stat_tracker.count_of_teams} teams." +
"The best and worst teams offensively were #{stat_tracker.best_offense} and #{stat_tracker.worst_offense}, respectively. \n" +
"The man was #{stat_tracker.winningest_coach("20172018")} in the 2017/18 season " +
"while #{stat_tracker.worst_coach("20172018")} was awful. "
puts ""
puts ""