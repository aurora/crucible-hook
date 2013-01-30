#!/usr/bin/env bash

JSMIN=$(which jsmin)
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DEST=$ROOT/web/hook.pack.js
DEPS=(
	$ROOT/src/vendor/jquery/jquery.js
	$ROOT/src/vendor/bpopup/jquery.bpopup-0.8.0.min.js
	$ROOT/src/vendor/highlight/highlight.pack.js
)

if [[ ! -d $ROOT/web ]]; then
	mkdir $ROOT/web
fi

# combine javascripts
if [[ "$JSMIN" != "" ]]; then
	jsmin <$ROOT/src/hook.js > $DEST
else
	cat $ROOT/src/hook.js > $DEST
fi

echo "" >> $DEST

for i in "${DEPS[@]}"; do 
	cat $i >> $DEST
	echo "" >> $DEST
done

# add styles
echo -n "jQuery(document).ready(function(\$) { \$('<style type=\"text/css\">" >> $DEST
tr -d '\n' < $ROOT/src/vendor/solarized/solarized_light.css >> $DEST
echo "</style>').appendTo(\$('head')); });" >> $DEST
