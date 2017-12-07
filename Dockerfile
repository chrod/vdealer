## Base Image: based on ubuntu for aarch64 (intended for Jetson TX2)
FROM aarch64/ubuntu
MAINTAINER nuculur@gmail.com

RUN apt-get update && apt-get -y upgrade && apt-get install -y ffmpeg
RUN apt-get install -y kmod

# Copy the video startup script (creates duplicate video endpoints & begins streams)
COPY video_startup.sh /
RUN chmod +x /video_startup.sh

## Run on container startup
CMD ["/video_startup.sh"]

#RUN apt-get autoremove && apt-get clean && rm -fr /tmp/*  #cleanup and docker --squash doesn't help much... 488MB container
