#!/usr/bin/zsh

CPUBURN_EXEC=burnP6

i=0
while [[ $i -lt $1 ]]; do
    $CPUBURN_EXEC &
    i=$(($i+1))
done
echo "Opened $i instances of cpuburn. Don't forget to kill them soon"
