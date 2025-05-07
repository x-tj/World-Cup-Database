#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams")

# read the games.csv file using cat and apply a while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 

#Get winner name
do
  if [[ $WINNER != "winner" ]]
  then
  # get TEAM1
    TEAM1=$($PSQL "SELECT name FROM teams WHERE name ='$WINNER'")
    # if not found
    if [[ -z $TEAM1 ]]
    then
      # insert TEAM1
      INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi


#Get opponent name
  if [[ $OPPONENT != "opponent" ]]
  then
  # get TEAM2
    TEAM2=$($PSQL "SELECT name FROM teams WHERE name ='$OPPONENT'")
    # if not found
    if [[ -z $TEAM2 ]]
    then
      # insert TEAM2
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi

#Get game data 
  if [[ $YEAR != "year" ]]
  then
  #get winner_id 
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
  # get Opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

    #Insert game data
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id,winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $? -eq 0 ]]
    then
    echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
    fi
  fi  
done
