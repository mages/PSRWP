#!/bin/bash

# Install jq to filter Github release data for Pandoc.
sudo apt-get -y install jq
# Get the latest .deb released.
wget `curl https://api.github.com/repos/jgm/pandoc/releases/latest | jq -r '.assets[] | .browser_download_url | select(endswith("deb"))'` -O pandoc.deb
sudo dpkg -i pandoc.deb

rm -rf out || exit 0;
mkdir out;

GH_REPO="@github.com/mages/PSRWP.git"

FULL_REPO="https://$GH_TOKEN$GH_REPO"

for files in '*.tar.gz'; do
tar xfz $files
done

#cd ./PSRWP/inst/doc
#R -e 'library(rmarkdown);render("PSRWP-Word.Rmd" )'
#cd ../../../

cd out
git init
git config user.name "mages-travis"
git config user.email "travis"
cp ../PSRWP/inst/doc/* .

mv PSRWP.html index.html

git add .
git commit -m "deployed to github pages"
git push --force --quiet $FULL_REPO master:gh-pages
