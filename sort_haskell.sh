#!/bin/bash

process_files() {
    local directory=$1

    find "${directory}" -type f \( -name "*.hs" -o -name "*.lhs" \) -exec grep -h "^import" {} \; \
    | grep " as " \
    | sed -r "s/ +as|import +|qualified +//g" \
    | sort \
    | uniq
}

export -f process_files

find stackage -mindepth 1 -maxdepth 1 -type d -print0 \
| xargs -0 -I{} bash -c 'process_files "$@"' _ {} \
| sort \
| uniq -c \
| sort -rn
