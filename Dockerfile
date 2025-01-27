# Use a lightweight Ubuntu image
FROM ubuntu:20.04

# Update and install FFmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

# Set the working directory
WORKDIR /app

# Copy the video file or script to the container
COPY your_video.mp4 /app/your_video.mp4

# FFmpeg command to stream to YouTube (replace $STREAM_KEY dynamically later)
CMD ["ffmpeg", "-re", "-stream_loop", "-1", "-i", "/app/your_video.mp4", "-c:v", "libx264", "-preset", "ultrafast", "-b:v", "1500k", "-maxrate", "1500k", "-bufsize", "3000k", "-pix_fmt", "yuv420p", "-f", "flv", "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"]
