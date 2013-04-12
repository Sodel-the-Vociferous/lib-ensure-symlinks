#!/bin/bash
# Written by Daniel Ralston
# Version 0.1

confirm_bool () {
    case $1 in
        y|Y)
            return 0;;
        *)
            return 1;;
    esac
}

confirm () {
    msg=$1
    double_confirm=$2

    echo "$msg"
    echo -n "[y/N]? "
    read -r y_or_n

    if [ "$double_confirm" ]
    then
        echo "Are you sure?"
        echo -n "[y/N]? "
        read -r y_or_n2

        # Choice changed?
        [ $(confirm_bool "$y_or_n") -eq $(confirm_bool "$y_or_n2") ] ||
        return 1
    fi

    confirm_bool "$y_or_n"; return $?
}

ensure_symlink () {
    target=$1
    lpath=$2

    # Link already exists, and is pointing at the right place?
    [ -L "$lpath" ] &&
    [ "$(readlink "$lpath")" = "$target" ] &&
    return 0

    if [ ! -e "$target" ]
    then
        echo "ERROR: Skipping '$lpath': link target '$target' does not exist!"
        return 1
    elif [ -d "$lpath" ]
    then
        # Dir exists; delete it?
        confirm "WARNING: '$lpath' is a directory! Link it to '$target'?" \
            "yes" ||
        return 1

        rm -rf "$lpath"
    elif [ -e "$lpath" ]
    then
        # File exists; delete it?
        confirm "WARNING: File '$lpath' exists. Delete it?" ||
        return 1

        rm "$lpath"
    fi

    # Create parent directories for the link if needed
    mkdir -p "$(dirname $lpath)"

    ln -s "$target" "$lpath" &&
    echo Linked "'$lpath'" to "'$target'"
}
