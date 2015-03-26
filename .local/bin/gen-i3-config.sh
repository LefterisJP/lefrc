#!/bin/bash

# generate machine specific i3 configuration file
cat ~/.i3/i3config.template > ~/.i3/config
# append specific work laptop stuff
if [ $HOSTNAME == "archlenovo" ]; then
   cat ~/.i3/i3workconfig.template >> ~/.i3/config
fi
# append specific home computer stuff
if [ $HOSTNAME == "archdesktop" ]; then
   cat ~/.i3/i3homeconfig.template >> ~/.i3/config
fi
#finally add the epilogue
cat ~/.i3/i3config_epilogue.template >> ~/.i3/config
