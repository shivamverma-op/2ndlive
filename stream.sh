#!/bin/bash

# Ensure the VIDEO_URL and STREAM_KEY are set
if [ -z "$VIDEO_URL" ]; then
  echo "Error: VIDEO_URL is not set."
  exit 1
fi

if [ -z "$STREAM_KEY" ]; then
  echo "Error: STREAM_KEY is not set."
  exit 1
fi

# Ensure cookies.json is available
if [ ! -f "/app/cookies.json" ]; then
  echo "Error: cookies.json not found in /app. Please provide the cookies file."
  exit 1
fi

# Download the best video and audio streams separately, using cookies.json for authentication
echo "Downloading video and audio from YouTube..."
yt-dlp --cookies /app/cookies.json -f bestvideo -o "/app/video.f%(ext)s" "$VIDEO_URL"
yt-dlp --cookies /app/cookies.json -f bestaudio -o "/app/audio.f%(ext)s" "$VIDEO_URL"

# Check if the files were downloaded
VIDEO_FILE=$(ls /app/video.f*)
AUDIO_FILE=$(ls /app/audio.f*)

if [ -z "$VIDEO_FILE" ] || [ -z "$AUDIO_FILE" ]; then
  echo "Error: Failed to download video or audio."
  exit 1
fi

# Merge the video and audio using ffmpeg
echo "Merging video and audio into a single file..."
ffmpeg -i "$VIDEO_FILE" -i "$AUDIO_FILE" -c:v copy -c:a aac -strict experimental /app/video.mp4

# Check if the merged file exists
if [ ! -f /app/video.mp4 ]; then
  echo "Error: Failed to merge video and audio."
  exit 1
fi

# Clean up the temporary video and audio files
rm -f /app/video.f* /app/audio.f*

# Start streaming to YouTube
echo "Starting the stream to YouTube..."
ffmpeg -re -i /app/video.mp4 -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

echo "Stream ended."
