#!/bin/bash

count=0
total=0

printf "Library path: "
read lib

function check {
    map="/proc/$1/maps"
    if [ ! -f $map ]; then
        return
    fi
    ((total++))
    exists=$(cat $map 2>/dev/null | grep $lib 2>/dev/null)
    if [[ $? != 0 ]]; then
        return
    else
        ((count++))
    fi
}

ps aux > file
awk -F" " 'FNR>1 {printf "%s\n", $2}' file > pids

while read -r line
do
    pid=$line
    check $pid
done < pids

percentage=$(echo $count/$total*100 | bc -l)

# Print Results
echo "Number of processes using the shared library: $count"
echo "Total number of processes: $total"
printf "%% of processes using the shared library: %0.2f\n" $percentage

# Clean up
rm file pids
