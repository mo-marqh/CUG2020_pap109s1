#!/bin/bash

for TEX in $( git diff --name-only $1 | grep tex )
do
  #echo $TEX
  [ -f "$TEX" ] || continue
  tex='.tex'
  fname=$(basename $TEX)
  dirname=$(basename $(dirname $TEX))
  apath=$(dirname $TEX)

  # delete the working directory if it exists
  # this is a bit fragile, but it only risks if
  # directory contains a directory of content with the same
  # dirname e.g. demo-project/demo-project/content
  # which seems unlikely
  if [ -d $apath/$dirname ]; then
    echo 'deleting...'
    rm -rf $apath/$dirname
  fi

  # only process the diff where name of controlling .tex file is 
  # the same as the name of the folder 
  if [ -f "$apath/$dirname$tex" ]; then

    # only do this once per directory, even if multi-hits on .tex changes
    if [ ! -d $apath/$dirname ]; then

      # only create the diff if there is a version in the upstream
      # (else latexdiff-git will error
      if git show $1:$apath/$dirname$tex | cat ; then

        mkdir $apath/$dirname
        CWD=$(pwd)
        cd $apath
        echo $(pwd)
        echo "latexdiff-git -r $1 --flatten -d $dirname $dirname$tex"
        latexdiff-git -r $1 --flatten -d $dirname $dirname$tex
        cd $CWD
        echo $(pwd)
        git add $apath/$dirname/$dirname$tex
      fi

    fi
  fi
done

exit
