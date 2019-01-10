#!/bin/sh
for d in ../ohol-family-trees/cache/*; do
  if [ -d "$d" ]; then
    ( cd "$d" && ls *_* | grep -v "names.txt" | xargs cat > all.txt )
  fi
done
