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

# default settings
HEADLESS="no"

# getopt setup
ARGS=$(getopt --options '' --longoptions headless -- "$@")
GETOPT_STATUS=$?

if [ $GETOPT_STATUS -ne 0 ]; then
    error "internal error; getopt exited with status $GETOPT_STATUS"
    exit 6
fi

eval set -- "$ARGS"

while :; do
    case "$1" in
        --headless) HEADLESS="yes" ;;
        --) shift; break ;;
        *) echo "internal error; getopt permitted \"$1\" unexpectedly"
           exit 6
           ;;
    esac
    shift
done

INPUT_DXF_FILE=$1
OUTPUT_PDF_FILE=$2

stop_background_processes() {
    echo killing librecad...
    echo kill -SIGTERM $librecad_pid
    kill -SIGTERM $librecad_pid || kill -SIGKILL $librecad_pid
    sleep 0.1
    if [[ $HEADLESS == yes ]]; then
        echo killing xvfb...
        echo kill -SIGQUIT $xvfb_pid
        kill -SIGQUIT $xvfb_pid
    fi
    exit
}

trap stop_background_processes INT  # this indicates that a keyboard interrupt should stop xvfb
trap stop_background_processes TERM
trap stop_background_processes QUIT

if [[ ! $OUTPUT_PDF_FILE =~ ^/.* ]]; then
    OUTPUT_PDF_FILE=$(pwd)/$OUTPUT_PDF_FILE
fi

if [[ $HEADLESS == yes ]]; then
    num=-1
    while true; do 
        num=$(expr $num + 1)
        xsocket=/tmp/.X11-unix/X$num
        test -S $xsocket || break
    done
    echo export DISPLAY=:$num
    export DISPLAY=unix:$num
    echo Xvfb :$num -screen 0 1024x768x24
    Xvfb :$num -screen 0 1024x768x24 &
    xvfb_pid=$!
    sleep 1
fi

echo librecad ${INPUT_DXF_FILE}
librecad ${INPUT_DXF_FILE} &
librecad_pid=$!

echo "sending xdotool commands..."

sleep 6
xdotool search --sync --class librecad windowfocus --sync 
sleep 0.5
# open up the print dialog
xdotool key ctrl+p
sleep 0.5
# focus the print dialog
xdotool windowfocus $(comm -12 <(xdotool search --sync --class "librecad" | sort) <(xdotool search --sync --name "print" | sort))
sleep 0.5
# focus on the printer dropdown
xdotool key alt+n
sleep 0.5
# select the PDF printer
xdotool key p
sleep 0.5
# focus on the output filename
xdotool key alt+f
sleep 0.5
# type out the file name
xdotool type "${OUTPUT_PDF_FILE}"
sleep 0.5
# save the file
xdotool key Return
sleep 0.5
xdotool search --sync --class librecad windowkill

stop_background_processes
