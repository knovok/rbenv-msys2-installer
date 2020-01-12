#!/bin/bash

set -e

apply_patches()
{
	for PATCH_FILE in $(find ../../patches -name *.patch); do
		patch < $PATCH_FILE
	done
}

wget https://github.com/rbenv/rbenv/archive/master.tar.gz -O rbenv.tar.gz
wget https://github.com/rbenv/ruby-build/archive/master.tar.gz -O ruby-build.tar.gz
tar -xzf rbenv.tar.gz
tar -xzf ruby-build.tar.gz

CWD=$(pwd)/rbenv-master
cd ${CWD}
PREFIX=$CWD ../ruby-build-master/install.sh
mv libexec/* bin

echo Applying patches...
cd bin
apply_patches
cd ..
if [ -z $RBENV_DESTDIR ]; then
	RBENV_DESTDIR=/usr/local/rbenv
	mkdir -p $RBENV_DESTDIR
fi
echo Installing rbenv to $RBENV_DESTDIR...
mv bin completions rbenv.d share CONDUCT.md LICENSE README.md $RBENV_DESTDIR
cd ..
rm -rf rbenv-master ruby-build-master rbenv.tar.gz ruby-build.tar.gz
echo Installed rbenv to $RBENV_DESTDIR
echo You are need to add $RBENV_DESTDIR/bin directory to PATH variable
