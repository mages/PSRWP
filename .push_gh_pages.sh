#!/bin/bash

rm -rf out || exit 0;
mkdir out;

GH_REPO="@github.com/mages/PSRWP.git"

FULL_REPO="https://$GH_TOKEN$GH_REPO"

for files in '*.tar.gz'; do
tar xfz $files
done

cd ./PSRWP/inst/doc
R -e 'library(knitr);knit("PSRWP-HTML.Rmd", "PSRWP-EPUB.md" )'
pandoc  PSRWP-EPUB.md --to epub3 --from markdown --output PSRWP-EPUB.epub --bibliography PSRWP.bib --number-sections --highlight-style tango --chapters --filter pandoc-citeproc --table-of-contents --toc-depth 2
cd ../../../

cd out
git init
git config user.name "mages-travis"
git config user.email "travis"
cp ../PSRWP/inst/doc/* .

mv PSRWP.html index.html

git add .
git commit -m "deployed to github pages"
git push --force --quiet $FULL_REPO master:gh-pages
