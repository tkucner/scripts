#!/bin/bash
NAME=thesis
if [ ! -d "build" ]; then
mkdir build
fi

latex -output-directory build/ $NAME.tex
if [ $? -eq 0 ]; then echo OK; else echo FAIL exit $?; fi

cp *.bib build

cd build

bibtex $NAME
if [ $? -eq 0 ]; then echo OK; else echo FAIL exit $?; fi

cd .. 

latex -output-directory build/ $NAME.tex
if [ $? -eq 0 ]; then echo OK; else echo FAIL; exit $?; fi

latex -output-directory build/ $NAME.tex
if [ $? -eq 0 ]; then echo OK; else echo FAIL; exit $?; fi

dvips -j0 -Ppdf -Pdownload35 -G0 build/$NAME.dvi  -o build/$NAME.ps 
if [ $? -eq 0 ]; then  echo OK; else echo FAIL; exit $?; fi

ps2pdf -dCompatibilityLevel=1.4 -dMaxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true build/$NAME.ps $NAME.pdf
if [ $? -eq 0 ]; then  echo OK; else echo FAIL; exit $?; fi
