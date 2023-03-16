#!/bin/bash


function stop_watching {
    echo "Stop watching..."
    exit
}

# inotifywait arguments defaults to "-e create -e moved_from -e modify"
# you can override it by setting the INOTIFYWAIT_ARGS environment variable
INOTIFYWAIT_ARGS=${INOTIFYWAIT_ARGS:--e create -e moved_from -e modify -e delete}

# delay in seconds between two executions of the command (default: 1)
DELAY=${DELAY:-1}

# command to execute when a inotify event is triggered (default: echo)
#COMMAND=${COMMAND:-echo}

set -e
if [[ -z $1 ]]; then
    echo "no directory to watch supplied"
    exit 1
fi
dir=$1

trap stop_watching SIGINT

echo "Start watching  '$dir' ..."
echo "inotifywait arguments: $INOTIFYWAIT_ARGS"
echo "delay: $DELAY"

while true; do
    inotifywait -r -m $INOTIFYWAIT_ARGS $dir | while read path action file; do
        # execute command if last execution was more than 1 second ago
        if [[ $(date +%s) -gt $((time + $DELAY)) ]]; then
            time=$(date +%s)
            eval "$COMMAND"
        fi
    done
done
