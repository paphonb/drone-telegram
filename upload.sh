#!/bin/bash

if [ -z "$MAJOR_MINOR" ]; then
    MAJOR_MINOR="alpha"
fi

# Adding body to changelog (intentional whitespace!!)
CHANGELOG=" <b>Changelog for build ${MAJOR_MINOR}-${DRONE_BUILD_NUMBER}</b>
$(cat changelog.txt)

<a href=\"${DRONE_REPO_LINK}/compare/${DRONE_PREV_COMMIT_SHA:0:8}...${DRONE_COMMIT_SHA:0:8}\">View on GitHub</a>"

# Preparing files to upload
cp $APK_PATH Lawnchair-${MAJOR_MINOR}_$DRONE_BUILD_NUMBER.apk

# Post build on Telegram
curl -F chat_id="$CHANNEL_ID" -F sticker="CAADBQADKAADTBCSGmapM3AUlzaHAg" https://api.telegram.org/bot$BOT_TOKEN/sendSticker
curl -F chat_id="$CHANNEL_ID" -F document=@"Lawnchair-${MAJOR_MINOR}_$DRONE_BUILD_NUMBER.apk" https://api.telegram.org/bot$BOT_TOKEN/sendDocument
curl -F chat_id="$CHANNEL_ID" -F text="$CHANGELOG" -F parse_mode="HTML" https://api.telegram.org/bot$BOT_TOKEN/sendMessage
