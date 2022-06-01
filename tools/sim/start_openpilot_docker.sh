#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

# expose X to the container
xhost +local:root

docker pull ghcr.io/commaai/openpilot-sim:latest

OPENPILOT_DIR="/openpilot"
if ! [[ -z "$MOUNT_OPENPILOT" ]]
then
  OPENPILOT_DIR="$(dirname $(dirname $DIR))"
  EXTRA_ARGS="-v $OPENPILOT_DIR:$OPENPILOT_DIR -e PYTHONPATH=$OPENPILOT_DIR:$PYTHONPATH"
fi

# video0 webcam
docker run --net=host\
  --name openpilot_client \
  --rm \
  -it \
  --device=/dev/dri:/dev/dri \
  --device=/dev/input:/dev/input \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$DIR/bridge_hamid.py":/openpilot/tools/sim/bridge_hamid.py \
  -v "$DIR/tmux_script.sh":/openpilot/tools/sim/tmux_script.sh \
  -v "$DIR/out.txt":/openpilot/tools/sim/out.txt \
  --device /dev/video0  --device /dev/video1 --device /dev/video2  --device /dev/video3  --device /dev/video4  --device /dev/video5 \
  --shm-size 1G \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  -w "$OPENPILOT_DIR/tools/sim" \
  $EXTRA_ARGS \
  ghcr.io/commaai/openpilot-sim:latest \
  /bin/bash -c "chmod +x ./tmux_script.sh; ./tmux_script.sh $*"
