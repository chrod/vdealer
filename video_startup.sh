#!/bin/bash
# Starts v4l2loopback, reproducing /dev/video1 to n additional devices
# Requires container to be run with access to /dev/ (mounted volume: -v /dev:/dev)

cleanup() {
  echo "vdealer: Cleaning up, stopping ffmpeg video duplication..."
  pid=`pgrep ffmpeg`
  kill -9 $pid 
  echo "stopped pid $pid. Sleeping 4 seconds..."
  sleep 1
  echo "vdealer: Cleaning up, removing v4l2loopback kernel module..."
  modprobe v4l2loopback -r
  echo "vdealer: Cleaned up."
  trap 'exit 0' SIGTERM   # Clear the trap
  #kill -- -$$             # Sends SIGTERM to child/sub processes
}

# Upon shutdown, execute cleanup (docker sends SIGTERM)
trap cleanup SIGTERM
echo "vdealer: Starting v4l2loopback kernel module, with n video devices..."
modprobe v4l2loopback video_nr=5,6,7
echo "vdealer: Video devices started."

# Video 5&6: dupe of video1 (video7 reserved for dev)
echo "vdealer: ffmpeg starting streaming duplication"
#ffmpeg -f v4l2 -i /dev/video1 -f v4l2 /dev/video5 -f v4l2 /dev/video6 > output.log 2>&1 &
ffmpeg -f v4l2 -i /dev/video1 -f v4l2 /dev/video5 -f v4l2 /dev/video6

# Just a loop to keep the container running
while true; do :; done
