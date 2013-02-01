#!/usr/bin/env bash

JSMIN=$(which jsmin)
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DEST=$ROOT/web/hook.pack.js
DEPS=(
    $ROOT/src/vendor/jquery/jquery.js
    $ROOT/src/vendor/highlight/highlight.pack.js
)

# combine javascripts
cat /dev/null > $DEST

for i in "${DEPS[@]}"; do 
    cat $i >> $DEST
    echo "" >> $DEST
done

if [[ "$JSMIN" != "" ]]; then
    jsmin <$ROOT/src/hook.js >> $DEST
else
    cat $ROOT/src/hook.js >> $DEST
fi

echo "" >> $DEST
