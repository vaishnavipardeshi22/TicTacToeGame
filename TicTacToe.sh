#!/bin/bash -x

echo " ****************************** WELCOME TO TIC TAC TOE GAME ****************************** "

#CONSTANT
ROWS=3
COLUMNS=3
SIGN=0

#DECLARE 2-DIMENSIONAL ARRAY
declare -A board

#FUNCTION TO RESET THE BOARD
function resetBoard()
{
	for((rows=0; rows<$ROWS; rows++))
	do
		for((columns=0; columns<$COLUMNS; columns++))
		do
			board[$rows,$columns]=" "
		done
	done
}

#FUNCTION TO ASSIGN LETTER TO PLAYER
function assignLetter()
{
	letterCheck=$((RANDOM % 2))
	if [ $letterCheck -eq $SIGN ]
	then
		echo player=O
		echo computer=X
	else
		echo player=X
		echo computer=O
	fi
}

#FUNCTION TO TOSS FOR WHO WILL PLAY FIRST
function whoPlayFirst()
{
	toss=$((RANDOM % 2))
	if [ $toss -eq $SIGN ]
	then
		echo "Computer wins the toss."
	else
		echo "Player wins the toss."
	fi
}

#FUNCTION TO DISPLAY BOARD
function displayBoard()
{
	echo "-------------"
	for((rows=0; rows<$ROWS; rows++))
	do
		for((columns=0; columns<$COLUMNS; columns++))
		do
			printf "| ${board[$rows,$columns]} "
		done
		printf "|"
		printf "\n"
		echo "-------------"
	done
}

resetBoard
assignLetter
whoPlayFirst
displayBoard
