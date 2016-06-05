#!/bin/sh

docker run -d -v /srv/owntracks:/owntracks -p 1883:1883 -p 8883:8883 -p 8083:8083 \
    --name owntracks-recorder \
    --hostname  www.example.com mqtt.example.com \
    -e MQTTHOSTNAME="mqtt.example.com" \
    -e OTR_USER="user??" \
    -e OTR_PASS="password??" \
    -e OT_CLIENT_ID="recorder" \
    owntracks/recorder
