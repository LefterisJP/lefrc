#!/bin/bash

# generate machine specific i3 configuration file
cat ~/.i3/i3config.template > ~/.i3/config
# for the laptop at work, setup the dual monitor setup
if [ $HOSTNAME == "archlenovo" ]; then
   cat ~/.i3/i3workconfig.template >> ~/.i3/config
fi
if [ $HOSTNAME == "archdesktop" ]; then
   cat ~/.i3/i3homeconfig.template >> ~/.i3/config
fi
#finally add the epilogue
cat ~/.i3/i3config_epilogue.template >> ~/.i3/config
