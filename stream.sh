#!/bin/bash

# Extract the direct video URL from the YouTube Shorts video
VIDEO_URL_EXTRACTED=$(yt-dlp -g "$VIDEO_URL")

# Use FFmpeg to stream the video to YouTube (replace YOUR_STREAM_KEY with the environment variable)
ffmpeg -i "$VIDEO_URL_EXTRACTED" -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k -pix_fmt yuv420p -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
