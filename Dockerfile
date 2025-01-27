# Start with a base image
FROM ubuntu:20.04

# Install FFmpeg
RUN apt-get update && apt-get install -y ffmpeg

# Copy the vertical video file
COPY your_video.mp4 /app/your_video.mp4

# Set the working directory
WORKDIR /app

# Run FFmpeg to stream to YouTube
CMD ["ffmpeg", "-re", "-stream_loop", "-1", "-i", "/app/your_video.mp4", "-vf", "scale=1080:1920", "-c:v", "libx264", "-preset", "ultrafast", "-b:v", "1500k", "-maxrate", "1500k", "-bufsize", "3000k", "-pix_fmt", "yuv420p", "-f", "flv", "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"]
