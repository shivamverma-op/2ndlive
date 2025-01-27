# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install FFmpeg and yt-dlp (for YouTube video URL extraction)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3-pip \
    && pip3 install -U yt-dlp \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy your script to the container
COPY stream.sh /app/

# Make the script executable
RUN chmod +x /app/stream.sh

# Define environment variables for YouTube stream key and video URL
ENV STREAM_KEY="gmbe-y8pu-jts8-h394-8uu6"
ENV VIDEO_URL="https://youtube.com/shorts/c9GjnPzBPvY?si=5aTFFzWhueenG8My"  # Your YouTube video URL

# Execute the script when the container starts
CMD ["/bin/bash", "/app/stream.sh"]
