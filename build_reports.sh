#!/bin/bash

git diff --name-only $1 

for TEX in $( git diff --name-only $1 | grep tex )
do
  [ -f "$TEX" ] || continue
  tex='.tex'
  fname=$(basename $TEX)
  dirname=$(basename $(dirname $TEX))
  apath=$(dirname $TEX)

  # only build the document who's name is the same as the name of the folder 
  if [ -f "$apath/$dirname$tex" ]; then
    THISTEX="$apath/$dirname$tex"
    echo $THISTEX
    echo pdflatex -output-directory=$apath $THISTEX
    TEXINPUTS=$apath/:styling/: pdflatex -shell-escape -halt-on-error -interaction=nonstopmode -output-directory=$apath $THISTEX && TEXINPUTS=$apath/:styling/: pdflatex -output-directory=$apath -shell-escape $THISTEX
    if [ $? -ne 0 ]; then
      echo "reporting exit code 1"
      exit 1
    fi
  fi
done

exit
