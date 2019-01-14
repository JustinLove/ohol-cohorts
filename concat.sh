#!/bin/sh
for d in ../ohol-family-trees/cache/*; do
  if [ -d "$d" ]; then
    pushd . > /dev/null
    cd "$d"
    echo -e "\r" > empty.txt
    NAMES=$(ls *_* | grep -v "names.txt")
    for file in $NAMES; do
      if [ -s $file ]; then
        cat $file empty.txt
      fi
    done > all.txt
    rm empty.txt
    popd > /dev/null
  fi
done
