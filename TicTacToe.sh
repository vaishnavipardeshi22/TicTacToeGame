#!/bin/bash -x

echo " ****************************** WELCOME TO TIC TAC TOE GAME ****************************** "

#CONSTANT
ROWS=3
COLUMNS=3

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

resetBoard
