#!/bin/bash


# for the desktop make sure that udiskie is running.
# TODO: Maybe do this in the work laptop too?
if [ $HOSTNAME == "archdesktop" ]; then
    udiskie &
fi

# generate machine specific i3 configuration file
cat ~/.i3/config.template > ~/.i3/config
# for the laptop at work, setup the dual monitor setup
if [ $HOSTNAME == "archlenovo" ]; then
   cat ~/.i3/worklenovo_config.template >> ~/.i3/config
fi
if [ $HOSTNAME == "archdesktop" ]; then
   cat ~/.i3/home_config.template >> ~/.i3/config
fi
#finally add the epilogue
cat ~/.i3/config_epilogue.template >> ~/.i3/config


exec i3 -V >> ~/.i3/i3log 2>&1
