#!/usr/bin/env bash
# set -eu
boardSize=3
row1="abc"
row2="def"
row3="ghi"
gameActive=1
## define a board
for ((i=1; i<=boardSize; i++)); do
	rowVar=row$i
  row=${!rowVar}
	output=""
	for ((j=0; j<boardSize; j++)); do
		char="${row:0:1}" 
		output+="$char | "
		row="${row:1}"
	done
	echo "${output:0:9}"
	if [[ $i < $boardSize ]]; then echo "--+---+--"; fi
done
echo "yeh"
echo ":: $row1 $row2 $row3"
## loop
# while gameActive; do

### get user choice
### test choice & report
### make npc choice
### test choice & report
