#!/usr/bin/env bash
boardSize=3
letters="abcdefghijklmnop"
horizontalLine="───┼"
margin="    "
gameActive=1
lineLength=$((boardSize * 4 - 1))
## define a board
echo

for ((i=0; i<boardSize; i++)); do
	row=${letters:((i * boardSize)):boardSize}
	output=""
	divider=""
	for ((j=0; j<boardSize; j++)); do
		char=${row:$j:1}
		output+=" $char │"
		divider+=$horizontalLine
	done
	echo "$margin${output:0:lineLength}"
	if [[ $i -lt $((boardSize - 1)) ]]; then echo "$margin${divider:0:lineLength}"; fi
done

echo

## loop
# while gameActive; do

### get user choice
### test choice & report
### make npc choice
### test choice & report
