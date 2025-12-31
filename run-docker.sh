#!/bin/bash
# Run JavaNNS in a Docker container with 32-bit Java

# Build the Docker image (only needed once)
if ! docker images | grep -q javanns; then
    echo "Building JavaNNS Docker image with 32-bit Java..."
    docker build -t javanns .
fi

# Check if X11 is available
if [ -z "$DISPLAY" ]; then
    echo "Warning: DISPLAY is not set. Running in headless mode."
    echo "To use the GUI, ensure X11 is running and DISPLAY is properly set."
    docker run --rm -it javanns
else
    # Run JavaNNS with X11 forwarding for GUI
    echo "Starting JavaNNS with X11 forwarding..."
    
    # Create a temporary Xauthority file for the container
    XAUTH=$(mktemp)
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
    
    docker run --rm -it \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        -v $XAUTH:/root/.Xauthority:rw \
        -e XAUTHORITY=/root/.Xauthority \
        --net=host \
        javanns
    
    # Clean up temporary Xauthority file
    rm -f $XAUTH
fi
