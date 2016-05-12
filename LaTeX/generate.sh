#!/bin/bash

WARNS_C=0

if [ "$#" -eq 0 ]; then
    NAME=main
elif [ "$#" -eq 1 ]; then
    NAME="$1"
else
    echo "Too many arguments"
    exit
fi

if [ ! -f $NAME.tex ]; then
    echo "File not found!"
    exit
fi

if [ ! -d "build" ]; then
    mkdir build
fi

pdflatex -interaction=nonstopmode -output-directory build/ $NAME.tex > build/build.log
if [ $? -eq 0 ]; then
    WARNS=$(grep 'LaTeX Warning' build/build.log)
    WARNS_C=$(grep -c 'LaTeX Warning' build/build.log)
    if [ $WARNS_C -ne 0 ]; then
        echo $WARNS
        echo WARNING
    else
        echo OK;
    fi
else
    sed -n '/! /,/l\./p' build/build.log
    echo FAIL;
    exit $?;
fi

if  [ `grep -c 'citation' build/$NAME.aux` -eq 1 ] && [ `grep -c 'bibdata' build/$NAME.aux` -eq 1 ]; then

    count=`ls -1 *.bib 2>/dev/null | wc -l`
    if [ $count != 0 ]; then
        cp *.bib build
        cd build
        bibtex $NAME
        if [ $? -eq 0 ]; then echo OK; else echo FAIL; exit $?; fi
        cd ..
    fi
fi

pdflatex -interaction=nonstopmode -output-directory build/ $NAME.tex > build/build.log
if [ $? -eq 0 ]; then
    WARNS=$(grep 'LaTeX Warning' build/build.log)
    WARNS_C=$(grep -c 'LaTeX Warning' build/build.log)
    if [ $WARNS_C -ne 0 ]; then
        echo $WARNS
        echo WARNING
    else
        echo OK;
    fi
else
    sed -n '/! /,/l\./p' build/build.log
    echo FAIL;
    exit $?;
fi

pdflatex -interaction=nonstopmode -output-directory build/ $NAME.tex > build/build.log
if [ $? -eq 0 ]; then
    WARNS=$(grep 'LaTeX Warning' build/build.log)
    WARNS_C=$(grep -c 'LaTeX Warning' build/build.log)
    if [ $WARNS_C -ne 0 ]; then
        echo $WARNS
        echo WARNING
    else
        echo OK;
    fi
else
    sed -n '/! /,/l\./p' build/build.log
    echo FAIL;
    exit $?;
fi

mv build/$NAME.pdf .

if [ $WARNS_C -ne 0 ]; then
    echo "Compilation succede there was $WARNS_C warnigns. Check build/build.log for warningn details."
fi

#dvips -j0 -Ppdf -Pdownload35 -G0 build/$NAME.dvi  -o build/$NAME.ps
#if [ $? -eq 0 ]; then  echo OK; else echo FAIL; exit $?; fi

#ps2pdf -dCompatibilityLevel=1.4 -dMaxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true build/$NAME.ps $NAME.pdf
#if [ $? -eq 0 ]; then  echo OK; else echo FAIL; exit $?; fi
