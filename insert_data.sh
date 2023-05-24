#! /bin/bash
if [[ $1 == "test" ]]
then
  echo "Testing..."
  PSQL="psql --username=postgres --dbname=world_cup_db_test -t --no-align -c"
else
  PSQL="psql --username=postgres --dbname=world_cup_db -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip the first row containing the column fields
  # insert records in teams table
  if [[ $YEAR != 'year' ]]
  then
    TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    if [[ -z $TEAM1_NAME ]]
    then
      INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      
      if [[ $INSERT_TEAM1_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted team $WINNER
      fi
    fi

    if [[ -z $TEAM2_NAME ]]
    then
      INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")

      if [[ $INSERT_TEAM2_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi
  fi

  # skip the first row 
  # insert records in games table
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ ! -z $WINNER_ID && ! -z $OPPONENT_ID ]]
    then 
      echo Inserting game: $WINNER_ID vs $OPPONENT_ID
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then
        echo Game record inserted: $YEAR, $ROUND, $WINNER_ID vs $OPPONENT_ID, score $WINNER_GOALS:$OPPONENT_GOALS
      fi  
    fi
  fi
done
