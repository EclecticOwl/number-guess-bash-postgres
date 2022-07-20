#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# TRUNCATE=$($PSQL "TRUNCATE users;")
# echo $TRUNCATE

echo -e "\nEnter your username:"
read USERNAME

CHECK_USERNAME=$($PSQL "select username, games_played, best_guesses from users where username = '$USERNAME'")


if [[ -z $CHECK_USERNAME ]]
  then
    INSERT_USER=$($PSQL "INSERT INTO users(username) values('$USERNAME');")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo $CHECK_USERNAME | while IFS='|' read USER GAMES GUESSES
  do
  echo "Welcome back, $USER! You have played $GAMES games, and your best game took $GUESSES guesses."
  done
fi

GET_RANDOM=$(( $RANDOM % 1000 ))
echo $GET_RANDOM

echo "Guess the secret number between 1 and 1000:"
TRIES=0
while read GUESS
do
  ((TRIES += 1))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
  elif [[ $GUESS > $GET_RANDOM ]]
    then
      echo "It's lower than that, guess again:"
 
  elif [[ $GUESS < $GET_RANDOM ]]
    then
      echo "It's higher than that, guess again:"
 
  elif [[ $GUESS == $GET_RANDOM ]]
    then
      break;
  fi
  
done

echo "You guessed it in $TRIES tries. The secret number was $GET_RANDOM. Nice job!"

CHECK_USERNAME=$($PSQL "select username, games_played, best_guesses from users where username = '$USERNAME'")

echo $CHECK_USERNAME | while IFS='|' read USER GAMES GUESSES
  do
    GAME_COUNT=$(($GAMES + 1))
    INSERT_SCORE=$($PSQL "update users set best_guesses = $TRIES, games_played = $GAME_COUNT")
  done


