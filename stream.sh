#!/bin/bash

# Check if the VIDEO_URL is empty
if [ -z "$VIDEO_URL" ]; then
  echo "Error: VIDEO_URL is not set. Please provide a valid URL."
  exit 1
fi

# Check if the STREAM_KEY is empty
if [ -z "$STREAM_KEY" ]; then
  echo "Error: STREAM_KEY is not set. Please provide a valid stream key."
  exit 1
fi

# Use yt-dlp to download the video and audio in best quality
echo "Downloading video and audio from YouTube..."
yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 "$VIDEO_URL" -o /app/video.%(ext)s

# Check if the video and audio files were downloaded
if [ ! -f /app/video.mp4 ]; then
  echo "Error: Failed to download the video."
  exit 1
fi

# If the download is in separate video and audio streams, try to merge them
if [ -f /app/video.f* ]; then
  echo "Merging video and audio streams..."
  ffmpeg -i /app/video.f* -c:v copy -c:a aac -strict experimental /app/video.mp4
  # Check if merging was successful
  if [ ! -f /app/video.mp4 ]; then
    echo "Error: Failed to merge video and audio streams."
    exit 1
  fi
fi

# Stream the video to YouTube using ffmpeg
echo "Starting the stream to YouTube..."
ffmpeg -re -i /app/video.mp4 -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

echo "Stream ended."
