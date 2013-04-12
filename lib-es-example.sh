#!/bin/bash

LIB_ES_PATH=~/src/lib-ensure-symlinks/lib-ensure-symlinks.sh

[ ! -e $LIB_ES_PATH ]
then
    echo "ERROR: lib-ensure-symlinks not found at '$LIB_ES_PATH'"
    exit 1
fi

source $LIB_ES_PATH
