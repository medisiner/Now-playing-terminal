#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

API_KEY=""
USERNAME=""

get_current_track() {
    local response=$(curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${USERNAME}&api_key=${API_KEY}&format=json")
    local now_playing=$(echo $response | jq -r '.recenttracks.track[0] | select(.["@attr"].nowplaying == "true") | "\(.artist["#text"]) - \(.name)"')
    local artist=$(echo $response | jq -r '.recenttracks.track[0].artist["#text"]')
    local track=$(echo $response | jq -r '.recenttracks.track[0].name')
    local cover_art=$(echo $response | jq -r '.recenttracks.track[0].image[-1]["#text"]')

    if [ -z "$now_playing" ]; then
        now_playing=$(echo $response | jq -r '.recenttracks.track[0] | "\(.artist["#text"]) - \(.name)"')
        echo -e "${YELLOW}Last played: ${NC}$now_playing"
    else
        echo -e "${GREEN}Now playing: ${NC}$now_playing"
    fi
}

clear
get_current_track
