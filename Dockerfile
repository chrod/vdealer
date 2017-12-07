## Base Image: based on ubuntu for aarch64 (intended for Jetson TX2)
FROM aarch64/ubuntu
MAINTAINER nuculur@gmail.com

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y kmod ffmpeg vim

# Copy the video startup script (creates duplicate video endpoints & begins streams)
COPY video_startup.sh /
RUN chmod +x /video_startup.sh

## Run on container startup
CMD ["/video_startup.sh"]

