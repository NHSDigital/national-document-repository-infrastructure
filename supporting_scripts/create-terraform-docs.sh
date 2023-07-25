#!/bin/bash
readonly os_type=$(uname)

if [[ "$os_type" == "Darwin"* ]]; then

    for directory in $(gfind ./ -regex '\./.[^.]*\/*.tf' -printf '%h\n' | sort -u)
    do
        eval "terraform-docs markdown $directory > $directory/README.md"
    done
else
    for directory in $(find ./ -regex '\./.[^.]*\/*.tf' -printf '%h\n' | sort -u)
    do
        eval "terraform-docs markdown $directory > $directory/README.md"
    done
fi