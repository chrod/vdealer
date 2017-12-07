### vdealer
A simple video device and streaming video duplication utility for linux (AARCH64 / [NVIDIA Jetson TX2](https://github.com/open-horizon/cogwerx-jetson-tx1/wiki/Initial-setup:-Jetson-TX1-and-TX2))

vdealer runs a script 'video_startup.sh', which does:
1) uses v4l2loopback to duplicate an existing video device /dev/video# to n other device copies.

   `modprobe v4l2loopback video_nr=5,6,7`  # duplicates /dev/video1 to /dev/video5, /dev/video6, and /dev/video7
   
2) uses ffmpeg to stream from /dev/video* to the extra devices created in (1)

   `ffmpeg -f v4l2 -i /dev/video1 -f v4l2 /dev/video5 -f v4l2 /dev/video6`  # streams output from /dev/video1 to /dev/video5 and 6

3) upon termination of the docker container, cleans up the ffmpeg streams and removes the devices created in (1)


#### Usage: 
Run as a docker container:

   `docker run --name vdealer -it --rm --privileged --ipc=host --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules aarch64-tx2-vdealer`
   
Because the container is pre-build with the CMD option, it will launch its script 'video_startup.sh' automatically
Options:  '-it' will run interactive, '-td' willrun in detached mode


#### Build: 
Build the docker container on your AARCH64 system:

   `docker build -f Dockerfile -t aarch64-tx2-vdealer .`

(or just pull the image: `docker pull openhorizon/aarch64-tx2-vdealer`)
   
##### Prerequisites:
OS / Architecture / System: Linux / AARCH64 / NVIDIA Jetson TX2 (as tested)
Supporting Kernel Modules: The kernel module [v4l2loopback](https://github.com/umlaeute/v4l2loopback) is required*

##### Caveats and Cautions:
This container is built to run on the NVIDIA Jetson TX2 with a custom kernel (compiled with these instructions), running JetPack3.1. 

*Caution: v4l2loopback must be built from *umlaeute*'s source, or you may run into (serious) device problems if kernel software conflicts.
