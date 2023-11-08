#!/bin/bash

SEARCH_DIR="/home/travis/"

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-d DIRECTORY]
Search for Haskell import statements within specified directory.

    -h              display this help and exit
    -d DIRECTORY    specify the directory to search in (default is $SEARCH_DIR)
EOF
}

process_files() {
    local directory=$1

    find "${directory}" -type f \( -name "*.hs" -o -name "*.lhs" \) -exec grep -h "^import" {} \; \
    | grep " as " \
    | sed -r "s/ +as|import +|qualified +//g" \
    | sort \
    | uniq
}

error() {
    local parent_lineno="$1"
    local message="$2"
    local code="${3:-1}"
    if [[ -n "$message" ]] ; then
        echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
    else
        echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
    fi
    exit "${code}"
}
trap 'error ${LINENO}' ERR

while getopts "hd:" opt; do
    case "$opt" in
        h)  
            show_help
            exit 0
            ;;
        d)  
            SEARCH_DIR=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done

export -f process_files

find "$SEARCH_DIR" -mindepth 1 -maxdepth 1 -type d -print0 \
| xargs -0 -I{} bash -c 'process_files "$@"' _ {} \
| sort \
| uniq -c \
| sort -rn
