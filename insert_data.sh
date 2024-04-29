#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo "Insert team $WINNER successfull!"
      fi

      WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    fi
  fi

  if [[ $OPPONENT != opponent ]]
  then
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo "Insert team $OPPONENT successfull!"
      fi

      OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    fi
  fi

  if [[ -n $WINNER_ID && -n $OPPONENT_ID ]]
  then
    INSERT_GAMES_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo "Insert games successfull!"
      fi
  fi
done
