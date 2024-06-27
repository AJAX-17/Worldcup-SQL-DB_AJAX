#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# truncating tables
echo $($PSQL "TRUNCATE games, teams")

# populating teams table & creating team_id
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get team_id from game winners
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team
     echo $($PSQL "insert into teams(name) values ('$WINNER')")
    fi
      
    # get team_id from game losers
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team
      echo $($PSQL "insert into teams(name) values ('$OPPONENT')")
    fi
    #populating games table & getting winner_id, opponent_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi

done
