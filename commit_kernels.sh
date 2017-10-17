#!/bin/sh

lift=$1

if [ -z "$1" ]
  then
    echo "No lift root supplied, failing"
    exit 1
fi

echo "lift root: $lift"

# assume we have pushd available
pushd $lift
# get the hash of the current lift version
lghash=$(git rev-parse HEAD)
echo "Retrieving kernels from lift version $lghash"
# go back
popd

# create a folder for that git repo
dname="kernels/$lghash"
mkdir -p $dname

# copy all the kernels from $lift/scripts/generated_programs/ to $dname
cp -r $lift/scripts/generated_programs/* $dname

# copy $dname to a folder for the head, after clearing it
hname="kernels/head"
mkdir -p $hname
rm -f $hname/*
cp -r $dname/* $hname

# add those files to git
git add $dname
git add $hname
git commit -a -m "add kernels from lift hash: $lghash"
