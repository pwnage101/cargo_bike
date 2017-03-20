#!/usr/bin/env bash

# constants
VIRTUAL_PROJECT_DIR=/home/user/project

# default settings
PROJECT_DIR=$(pwd)
HEADLESS="no"
DOCKER_IMAGE="freecad-ubuntu"
COMMAND="freecad-daily ${VIRTUAL_PROJECT_DIR}/macros/export_drawings.FCScript"

# getopt setup
ARGS=$(getopt --options '' --longoptions headless,project-dir: -- "$@")
GETOPT_STATUS=$?

if [ $GETOPT_STATUS -ne 0 ]; then
    error "internal error; getopt exited with status $GETOPT_STATUS"
    exit 6
fi

eval set -- "$ARGS"

while :; do
    case "$1" in
        --headless) HEADLESS="yes" ;;
        --project-dir) PROJECT_DIR="$2"; shift ;;
        --) shift; break ;;
        *) echo "internal error; getopt permitted \"$1\" unexpectedly"
           exit 6
           ;;
    esac
    shift
done

if [[ $HEADLESS = yes ]]; then
    DISPLAY=:1
else
    DISPLAY=:0
fi

stop_xvfb() {
    kill -SIGINT $(jobs -p)
}

trap stop_xvfb INT  # this indicates that a keyboard interrupt should stop xvfb
trap stop_xvfb TERM
trap stop_xvfb QUIT

if [[ $HEADLESS == yes ]]; then
    Xvfb $DISPLAY -screen 0 1024x768x24 &  # starts Xvfb
fi

docker run -ti --rm -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${PROJECT_DIR}:${VIRTUAL_PROJECT_DIR} \
    $DOCKER_IMAGE $COMMAND

if [[ $HEADLESS == yes ]]; then
    stop_xvfb
fi
