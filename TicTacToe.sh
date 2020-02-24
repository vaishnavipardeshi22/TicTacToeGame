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
		player=O
		computer=X
	else
		player=X
		computer=O
	fi
	echo "Player=$player"
	echo "Computer=$computer"
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

#FUNCTION TO CHECK WINNER
function getWinner()
{
	local player=$1
	column=0
	flag=false

	for((row=0; row<$ROWS; row++))
	do
		if [[ ${board[$row,$column]}${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} == $player$player$player ]]
		then
			flag=true
			printf "$flag"
			return
		fi
	done

	row=0
	for((column=0; column<$COLUMNS; column++))
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $player$player$player ]]
		then
			flag=true
			printf "$flag"
			return
		fi
	done

	row=0
	column=0
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $player$player$player ]]
	then
		flag=true
		printf "$flag"
		return
	elif [[ ${board[$row,$(($column+2))]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$column]} == $player$player$player ]]
	then
		flag=true
		printf "$flag"
		return
	fi
	echo $flag
}

resetBoard
assignLetter
whoPlayFirst
displayBoard
board[0,2]=X
board[1,1]=X
board[2,0]=X
displayBoard
getWinner $computer
