#!/bin/sh

eval $(op signin)

SPOTIFY_USERNAME=$(op read op://Personal/Spotify/username)
SPOTIFY_PASSWORD=$(op read op://Personal/Spotify/password)

spotifyd --username $SPOTIFY_USERNAME --password $SPOTIFY_PASSWORD

spt
