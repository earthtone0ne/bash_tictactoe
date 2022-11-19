#!/usr/bin/env bash
gameActive=1
boardSize=3
horizontalLine="───┼"
margin="    "
lineLength=$((boardSize * 4 - 1))
letters="abcdefghijklmnop"
availableLetters=${letters:0:((boardSize * boardSize))}
playerToken="Ⓞ"
npcToken="╳"
playerSquares=""
npcSquares=""
## define a board
echo

function drawGrid()	{
	clear
	for ((i=0; i<boardSize; i++)); do
		row=${letters:((i * boardSize)):boardSize}
		output=""
		divider=""
		for ((j=0; j<boardSize; j++)); do
			char=${row:$j:1}
			if [[ $playerSquares == *"$char"* ]]; then
				char=$playerToken
			elif [[ $npcSquares == *"$char"* ]]; then
			  char=$npcToken
			fi
			output+=" $char │"
			divider+=$horizontalLine
		done
		echo "$margin${output:0:lineLength}"
		if [[ $i -lt $((boardSize - 1)) ]]; then
			echo "$margin${divider:0:lineLength}";
		else
			echo
		fi
	done
}

## loop
while [ $gameActive = 1 ]; do
	drawGrid
	### get user choice
	echo "Select a space: [$availableLetters]"
	read -r userChoice
	echo "Selected: $userChoice"
	if [[ $availableLetters == *"$userChoice"* ]]; then
		playerSquares+=$userChoice
		availableLetters=${availableLetters/${userChoice}}
		
		### test choice & report result
		######### TODO

		sleep 1
		drawGrid

		### make npc choice
		availableLen=${#availableLetters}
		npcIndex=$(( RANDOM % (availableLen - 1) ))
		npcChoice=${availableLetters:$npcIndex:1}
		npcSquares+=$npcChoice
		availableLetters=${availableLetters/${npcChoice}}
		echo "Computer chose: $npcChoice"
		sleep 1
		drawGrid

		### test choice & report result
		######### TODO

	else
		echo 'Not a valid selection. Try again.'
		sleep 1
	fi
	if [[ ${#availableLetters} == 0 ]]; then
		gameActive=0
	fi
done


