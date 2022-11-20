#!/usr/bin/env bash
# values for drawing a board
boardSize=3
horizontalLine="───┼"
margin="           "
lineLength=$((boardSize * 4 - 1))
letters="abcdefghijklmnop"
# colors
C_NPC="\033[0;36m"
C_HUMAN="\033[0;35m"
C_RESET="\033[0m"
# players
humanDesc="Human person"
npcDesc="Computer"
humanToken="${C_HUMAN}◉${C_RESET}"
npcToken="${C_NPC}✖${C_RESET}"
# game state
gameActive=1
availableLetters=${letters:0:((boardSize * boardSize))}
humanSquares=""
npcSquares=""
winningCombos=(abc aei adg beh cfi ceg def ghi)

function drawGrid()	{
	clear
	echo -e "\n\n"
	for ((i=0; i<boardSize; i++)); do
		row=${letters:((i * boardSize)):boardSize}
		output=""
		divider=""
		for ((j=0; j<boardSize; j++)); do
			char="${row:$j:1}"
			if [[ $humanSquares == *"$char"* ]]; then
				char=$humanToken
			elif [[ $npcSquares == *"$char"* ]]; then
			  char=$npcToken
			fi
			output+=" $char │"
			divider+=$horizontalLine
		done
		echo -e "$margin${output%│}"
		if [[ $i -lt $((boardSize - 1)) ]]; then
			echo -e "$margin${divider:0:lineLength}";
		else
			echo
		fi
	done
	echo
}

function checkForWin() {
	# every win contains one of [aei] and has length 3
	if [[ ! ${#1} -ge 3 || $1 != *[aei]* ]]; then
		return
	fi
	for combo in "${winningCombos[@]}"
	do
		# if player has all three letters of any combo, they win
		regx="[$combo].*[$combo].*[$combo]"
		if [[ $1 =~ $regx ]]; then 
			# change winner's tokens to bold, print result in their color
			if [ "$2" == "$npcDesc" ]; then
				npcToken=${npcToken/0;/1;}
				color=$C_NPC
			else
				humanToken=${humanToken/0;/1;}
				color=$C_HUMAN
			fi
			drawGrid
			echo -e "$color$2 WINNNS!!!!!!!$C_RESET\n"
			gameActive=0
			break
		fi
	done
}

## loop
while [ $gameActive = 1 ]; do
	drawGrid
	# get user choice
	echo "Select a space: [$availableLetters]"
	read -r userChoice
	echo "Selected: $userChoice"
	if [[ ! -z $userChoice && $availableLetters == *$userChoice* ]]; then
		# add letter to human's collection and remove from available letters
		humanSquares+=$userChoice
		availableLetters=${availableLetters/${userChoice}}
		# reflect the change in the grid
		drawGrid
		echo "Selected: $userChoice"
		
		# test choice & report result
		checkForWin "$humanSquares" "$humanDesc"
		# if user won, end game
		if [[ $gameActive == 1 && ${#availableLetters} -ge 1 ]]; then
			sleep 1
			# make npc choice by picking a random available letter
			availableLen=${#availableLetters}
			npcIndex=$(( RANDOM % (availableLen - 1) ))
			npcChoice=${availableLetters:$npcIndex:1}
			npcSquares+=$npcChoice
			availableLetters=${availableLetters/${npcChoice}}
			drawGrid
			echo "Computer chose: $npcChoice"

			# test choice & report result
			checkForWin "$npcSquares" "$npcDesc"
			sleep 1
		fi

	else
		echo 'Not a valid selection. Try again.'
		sleep 1
	fi
	if [[ ${#availableLetters} == 0 ]]; then
		echo "Game ends in a draw. Thanks for playing!"
		gameActive=0
	fi
done


