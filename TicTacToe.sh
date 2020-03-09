#!/bin/bash -x

echo " ****************************** WELCOME TO TIC TAC TOE GAME ****************************** "

#CONSTANTS
ROWS=3
COLUMNS=3
SIGN=0
TOTAL_NUMBER_OF_CELL=9
IS_EMPTY=" "

#VARIABLE
turnCount=0

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
	winnerFlag=false

	#CHECK ROW WISE
	column=0
	for((row=0; row<$ROWS; row++))
	do
		if [[ ${board[$row,$column]}${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} == $player$player$player ]]
		then
			winnerFlag=true
			return
		fi
	done

	#CHECK COLUMN WISE
	row=0
	for((column=0; column<$COLUMNS; column++))
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $player$player$player ]]
		then
			winnerFlag=true
			return
		fi
	done

	#CHECK DIAGONAL WISE
	row=0
	column=0
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $player$player$player ]]
	then
		winnerFlag=true
		return
	elif [[ ${board[$row,$(($column+2))]}${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$column]} == $player$player$player ]]
	then
		winnerFlag=true
		return
	fi
}

#FUNCTION TO CHECK WINNING MOVE FOR COMPUTER
function checkComputerWinMove()
{
	local playerCheck=$1

	#CHECK ROW WISE
	column=0
	for((row=0; row<$ROWS; row++))
	do
		if [[ ${board[$row,$column]}${board[$row,$(($column+1))]} == $playerCheck$playerCheck && ${board[$row,$(($column+2))]} == $IS_EMPTY ]]
		then
			board[$row,$(($column+2))]=$computer
			turnPlay=1
			return
		elif [[ ${board[$row,$column]}${board[$row,$(($column+2))]} == $playerCheck$playerCheck && ${board[$row,$(($column+1))]} == $IS_EMPTY ]]
		then
			board[$row,$(($column+1))]=$computer
			turnPlay=1
			return
		elif [[ ${board[$row,$(($column+1))]}${board[$row,$(($column+2))]} == $playerCheck$playerCheck && ${board[$row,$column]} == $IS_EMPTY ]]
		then
			board[$row,$column]=$computer
			turnPlay=1
			return
		fi
	done

	#CHECK COLUMN WISE
	row=0
	for((column=0; column<$COLUMNS; column++))
	do
		if [[ ${board[$row,$column]}${board[$(($row+1)),$column]} == $playerCheck$playerCheck && ${board[$(($row+2)),$column]} == $IS_EMPTY ]]
		then
			board[$(($row+2)),$column]=$computer
			turnPlay=1
			return
		elif [[ ${board[$row,$column]}${board[$(($row+2)),$column]} == $playerCheck$playerCheck && ${board[$(($row+1)),$column]} == $IS_EMPTY ]]
		then
			board[$(($row+1)),$column]=$computer
			turnPlay=1
			return
		elif [[ ${board[$(($row+1)),$column]}${board[$(($row+2)),$column]} == $playerCheck$playerCheck && ${board[$row,$column]} == $IS_EMPTY ]]
		then
			board[$row,$column]=$computer
			turnPlay=1
			return
		fi
	done

	#CHECK DIAGONAL AT POSITION ([0,0] [1,1] [2,2]) WISE
	row=0
	column=0
	if [[ ${board[$row,$column]}${board[$(($row+1)),$(($column+1))]} == $playerCheck$playerCheck && ${board[$(($row+2)),$(($column+2))]} == $IS_EMPTY ]]
	then
		board[$(($row+2)),$(($column+2))]=$computer
		turnPlay=1
		return
	elif [[ ${board[$row,$column]}${board[$(($row+2)),$(($column+2))]} == $playerCheck$playerCheck && ${board[$(($row+1)),$(($column+1))]} == $IS_EMPTY ]]
	then
		board[$(($row+1)),$(($column+1))]=$computer
		turnPlay=1
		return
	elif [[ ${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$(($column+2))]} == $playerCheck$playerCheck && ${board[$row,$column]} == $IS_EMPTY ]]
	then
		board[$row,$column]=$computer
		turnPlay=1
		return
	fi

	#CHECK DIAGONAL AT POSITION ([0,2] [1,1] [2,0]) WISE
	if [[ ${board[$row,$(($column+2))]}${board[$(($row+1)),$(($column+1))]} == $playerCheck$playerCheck && ${board[$(($row+2)),$column]} == $IS_EMPTY ]]
	then
		board[$(($row+2)),$column]=$computer
		turnPlay=1
		return
	elif [[ ${board[$row,$(($column+2))]}${board[$(($row+2)),$column]} == $playerCheck$playerCheck && ${board[$(($row+1)),$(($column+1))]} == $IS_EMPTY ]]
	then
		board[$(($row+1)),$(($column+1))]=$computer
		turnPlay=1
		return
	elif [[ ${board[$(($row+1)),$(($column+1))]}${board[$(($row+2)),$column]} == $playerCheck$playerCheck && ${board[$row,$(($column+2))]} == $IS_EMPTY ]]
	then
		board[$row,$(($column+2))]=$computer
		turnPlay=1
		return
	fi
}

#FUNCTION TO TAKE CORNER FOR COMPUTER IF WINNING POSIBILITIES ARE NOT AVAILABLE
function takeCornerMove()
{
	rowCell=$(( RANDOM % 3 ))
	columnCell=$(( RANDOM % 3 ))

	row=0
	column=0

	while [[ ${board[$rowCell,$columnCell]} != $IS_EMPTY ]]
	do
		rowCell=$(( RANDOM % 3 ))
		columnCell=$(( RANDOM % 3 ))
	done

	if [[ $rowCell == $row && $columnCell == $column ]]
	then
		board[$rowCell,$columnCell]=$computer
		turnPlay=1
		return
	elif [[ $rowCell == $row && $columnCell == $(($column+2)) ]]
	then
		board[$rowCell,$columnCell]=$computer
		turnPlay=1
		return
	elif [[ $rowCell == $(($row+2)) && $columnCell == $(($column+2)) ]]
	then
		board[$rowCell,$columnCell]=$computer
		turnPlay=1
		return
	elif [[ $rowCell == $(($row+2)) && $columnCell == $column ]]
	then
		board[$rowCell,$columnCell]=$computer
		turnPlay=1
		return
	else
		takeCornerMove
	fi
}

#TAKE CENTRE MOVE IF CORNERS ARE NOT EMPTY
function takeCentreMove()
{
	row=0
	column=0

	if [[ ${board[$(($row+1)),$(($column+1))]} == $IS_EMPTY ]]
	then
		board[$(($row+1)),$(($column+1))]=$computer
		turnPlay=1
		return
	fi
}

#FUNCTION FOR PLAYER TURN
function playerTurn()
{
	while [ $turnCount -ne $TOTAL_NUMBER_OF_CELL ]
	do
		if [[ $playerTurnFlag == false ]]
		then
			echo "$player Turn: "
			((turnCount++))
			read -p "Enter number of row cell: " rowCell
			read -p "Enter number of column cell: " columnCell

			while [[ $rowCell -lt 0 || $columnCell -lt 0 || $rowCell -gt 2 || $columnCell -gt 2 ]]
			do
				echo "Invalid cell."
				read -p "Enter number of row cell: " rowCell
				read -p "Enter number of column cell: " columnCell
			done

			while [[ ${board[$rowCell,$columnCell]} != $IS_EMPTY ]]
			do
				echo "Cell is occupied enter another value."
				read -p "Enter number of row cell: " rowCell
				read -p "Enter number of column cell: " columnCell
			done

			board[$rowCell,$columnCell]=$player
			displayBoard
			getWinner $player
			if [[ $winnerFlag == true ]]
			then
				printf "Player $player wins the game."
				return
			fi
			playerTurnFlag=true
		else
			turnPlay=0
			echo "$computer Turn: "
			((turnCount++))

			#FUNCTION CALL FOR COMPUTER WIN MOVES
			checkComputerWinMove $computer

			#FUNCTION CALL FOR BLOCK THE OPPOENENT 
			if [ $turnPlay -eq 0 ]
			then
				checkComputerWinMove $player
			fi

			#FUNCTION CALL FOR CORNER MOVE FOR COMPUTER
			if [ $turnPlay -eq 0 ]
			then
				takeCornerMove
			fi

			#FUNCTION CALL FOR CENTER MOVE
			if [ $turnPlay -eq 0 ]
			then
				takeCentreMove
			fi

			#TAKE SIDES RANDOMLY AT LAST
			if [ $turnPlay -eq 0 ]
			then
				rowCell=$(( RANDOM % 3 ))
				columnCell=$(( RANDOM % 3 ))

				while [[ ${board[$rowCell,$columnCell]} != $IS_EMPTY ]]
				do
					rowCell=$(( RANDOM % 3 ))
					columnCell=$(( RANDOM % 3 ))
				done
				board[$rowCell,$columnCell]=$computer
			fi

			displayBoard
			getWinner $computer
			if [[ $winnerFlag == true ]]
			then
				printf "Computer wins the game."
				return
			fi
			playerTurnFlag=false
		fi

		if [[ $turnCount == $TOTAL_NUMBER_OF_CELL && $winnerFlag == false ]]
		then
			printf "Match tie."
		fi
	done
}

resetBoard
assignLetter
whoPlayFirst

if [[ $tossWinner == $computer ]]
then
	playerTurnFlag=true
	playerTurn
else
	playerTurnFlag=false
	displayBoard
	playerTurn
fi
