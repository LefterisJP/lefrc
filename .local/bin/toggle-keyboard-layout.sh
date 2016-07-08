#!/bin/bash


LANG1="us"
LANG2="el"
CURRENT_LANG=$(setxkbmap -query | tail -n 1 | cut -f6 -d ' ')
if [ "$CURRENT_LANG" = $LANG1 ]; then
    setxkbmap $LANG2
else
    setxkbmap $LANG1
fi
