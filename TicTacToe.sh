#!/bin/bash -x

echo " ****************************** WELCOME TO TIC TAC TOE GAME ****************************** "

#CONSTANT
ROWS=3
COLUMNS=3
SIGN=0
TOTAL_NUMBER_OF_CELL=9
IS_EMPTY=" "

#VARIABLE
playerTurnCount=0

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
		tossWinner=$computer
	else
		echo "Player wins the toss."
		tossWinner=$player
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
			return
		fi
	done

	row=0
	for((column=0; column<$COLUMNS; column++))
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $player$player$player ]]
		then
			flag=true
			return
		fi
	done

	row=0
	column=0
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $player$player$player ]]
	then
		flag=true
		return
	elif [[ ${board[$row,$(($column+2))]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$column]} == $player$player$player ]]
	then
		flag=true
		return
	fi
	echo $flag
}

#FUNCTION FOR PLAYER TURN
function playerTurn()
{
	while [ $playerTurnCount -ne $TOTAL_NUMBER_OF_CELL ]
	do
		if [[ $flagSet == false ]]
		then
			echo "Player $player Turn: "
			((playerTurnCount++))
			read -p "Enter number of row cell: " rowCell
			read -p "Enter number of column cell: " columnCell

			while [[ ${board[$rowCell,$columnCell]} != $IS_EMPTY ]]
			do
				echo "Cell is already occupied enter another cell value."
				read -p "Enter number of row cell: " rowCell
				read -p "Enter number of column cell: " columnCell
			done

			board[$rowCell,$columnCell]=$player
			displayBoard
			getWinner $player
			if [[ $flag == true ]]
			then
				printf "Player $player wins the game."
				return
			fi
			flagSet=true
		else
			echo "Computer $computer Turn: "
			((playerTurnCount++))
			rowCell=$(( RANDOM % 3 ))
			columnCell=$(( RANDOM % 3 ))

			while [[ ${board[$rowCell,$columnCell]} != $IS_EMPTY ]]
			do
				rowCell=$(( RANDOM % 3 ))
				columnCell=$(( RANDOM % 3 ))
			done

			board[$rowCell,$columnCell]=$computer
			displayBoard
			getWinner $computer
			if [[ $flag == true ]]
			then
				printf "Computer $computer wins the game."
				return
			fi
			flagSet=false
		fi
	done
}

resetBoard
assignLetter
whoPlayFirst

if [[ $tossWinner == $computer ]]
then
	flagSet=true
	playerTurn
else
	flagSet=false
	displayBoard
	playerTurn
fi
