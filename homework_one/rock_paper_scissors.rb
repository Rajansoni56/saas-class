class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

# Verify that the move is P, R or S
def valid_move?(move)
  %w(p s r).include? move.downcase
end

# Given two strategies, say if the first player wins
def wins?(player, opponent)
  player.upcase!
  opponent.upcase!

  # Return true if one of the following:
  #  * Both players use the same strategy
  #  * R > S
  #  * S > P
  #  * P > R
  (player == opponent) or
  (player == "R" and opponent == "S") or
  (player == "S" and opponent == "P") or
  (player == "P" and opponent == "R")
end

# Given a match, returns the winner.
# The match is a 2 position array like this:
#   [ [name, str], [name, str] ]
#
# name: The name of the player
# str: The strategy used (P, R, S)
def rps_game_winner(game)
  player, opponent = game.first.last, game.last.last
  raise WrongNumberOfPlayersError unless game.length == 2
  raise NoSuchStrategyError unless valid_move?(player) and valid_move?(opponent)
  return game.first if wins?(player, opponent)
  game.last
end

# Given a full tournament, returns the winner.
# The tournament is a binary tree of games.
def rps_tournament_winner(tournament)
  if tournament.first.first.is_a?(String)
    rps_game_winner(tournament)
  else
    winner_left  = rps_tournament_winner(tournament.first)
    winner_right = rps_tournament_winner(tournament.last)
    rps_tournament_winner([winner_left, winner_right])
  end
end

tournament = [
              [
               [ ["Armando", "P"], ["Dave", "S"]],
               [ ["Richard", "R"], ["Michael", "S"]]
              ],
              [
               [ ["Allen", "S"], ["Omer", "P"]],
               [ ["David E.", "R"], ["Richard X", "P"]]
              ]
             ]

p rps_tournament_winner(tournament)
