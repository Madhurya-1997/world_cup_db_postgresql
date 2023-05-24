#! /bin/bash

PSQL="psql --username=postgres --dbname=world_cup_db_test --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo -e "$($PSQL "SELECT SUM(winner_goals+opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo -e "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo -e "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo -e "$($PSQL "SELECT AVG(winner_goals+opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo -e "$($PSQL "SELECT MAX(winner_goals) FROM games;")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo -e "$($PSQL "SELECT COUNT(winner_goals) FROM games WHERE winner_goals > 2;")"

echo -e "\nWinner of the 2018 tournament team name:"
echo -e "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE games.year = 2018 AND games.round='Final';")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo -e "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id OR games.opponent_id=teams.team_id WHERE games.round='Eighth-Final' AND games.year=2014 ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo -e "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id GROUP BY name ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo -e "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE games.round='Final' ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
echo -e "$($PSQL "SELECT name FROM teams WHERE teams.name LIKE 'Co%'")"
