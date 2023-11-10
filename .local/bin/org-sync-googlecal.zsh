#!/bin/zsh

# customize these
WGET=/usr/bin/wget
ICS2ORG=/home/lefteris/.local/bin/ical2org.awk
ICSFILE=~/org/calendars/googlecal.ics
ORGFILE=~/org/calendars/googlecal.org
# Fin in https://calendar.google.com/calendar/u/0/r/settings/calendar/ and customize after copying the file. Do not commit
URL=PUPRIVATEICALGMAILLINKHERE

# no customization needed below

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
