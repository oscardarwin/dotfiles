#!/bin/sh

NUM_SPOTIFYD_DAEMONS=`pgrep -fl "spotifyd --username" | wc -l` 

if [ $NUM_SPOTIFYD_DAEMONS -eq 0 ]; then
  echo "Launching spotifyd daemon"

  eval $(op signin)
  
  SPOTIFY_USERNAME=$(op read op://Personal/Spotify/username)
  SPOTIFY_PASSWORD=$(op read op://Personal/Spotify/password)

  spotifyd --username $SPOTIFY_USERNAME --password $SPOTIFY_PASSWORD
fi

spt
