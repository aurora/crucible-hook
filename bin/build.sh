#!/usr/bin/env bash

JSMIN=$(which jsmin)
ROOT=$(cd "$(dirname "$0")/.." && pwd)

if [[ ! -d $ROOT/web ]]; then
	mkdir $ROOT/web
fi

if [[ "$JSMIN" != "" ]]; then
	jsmin <$ROOT/src/hook.js | cat - \
		$ROOT/src/vendor/jquery/jquery.js \
		$ROOT/src/vendor/bpopup/jquery.bpopup-0.8.0.min.js \
		$ROOT/src/vendor/highlight/highlight.pack.js > $ROOT/web/hook.pack.js
else
	cat $ROOT/src/hook.js \
		$ROOT/src/vendor/jquery/jquery.js \
		$ROOT/src/vendor/bpopup/jquery.bpopup-0.8.0.min.js \
		$ROOT/src/vendor/highlight/highlight.pack.js > $ROOT/web/hook.pack.js
fi
