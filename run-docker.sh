#!/bin/bash
# Run JavaNNS in a Docker container with 32-bit Java

# Build the Docker image (only needed once)
if ! docker images | grep -q javanns; then
    echo "Building JavaNNS Docker image with 32-bit Java..."
    docker build -t javanns .
fi

# Run JavaNNS with X11 forwarding for GUI
echo "Starting JavaNNS..."
docker run --rm -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority \
    --net=host \
    javanns
