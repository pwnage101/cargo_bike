#!/usr/bin/env bash
#
# Copyright © 2017 Troy Sankey <sankeytms at gmail dot com>
# 
# This documentation describes Open Hardware and is licensed under the CERN OHL
# v1.2.  You may redistribute and modify this documentation under the terms of
# the CERN OHL v1.2 (http://ohwr.org/cernohl). This documentation is
# distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF
# MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE.
# Please see the CERN OHL v1.2 for applicable conditions.
#
# FIXME: descript the function of this script

# constants
VIRTUAL_PROJECT_DIR=/home/user/project

# default settings
PROJECT_DIR=$(pwd)
HEADLESS="no"
DOCKER_IMAGE=${DOCKER_IMAGE:-"freecad-ubuntu"}
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

docker run -ti --rm -e DISPLAY=unix$DISPLAY --net=none \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${PROJECT_DIR}:${VIRTUAL_PROJECT_DIR} \
    $DOCKER_IMAGE $COMMAND

if [[ $HEADLESS == yes ]]; then
    stop_xvfb
fi
