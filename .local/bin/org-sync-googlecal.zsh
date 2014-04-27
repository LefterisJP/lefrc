#!/bin/zsh

# customize these
WGET=/usr/bin/wget
ICS2ORG=/home/lefteris/.local/bin/ical2org.awk
ICSFILE=~/org/calendars/googlecal.ics
ORGFILE=~/org/calendars/googlecal.org
URL=https://www.google.com/calendar/ical/lefterisjp%40gmail.com/private-357fc2ac62c5a2e02827193a83b03279/basic.ics

# no customization needed below

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE