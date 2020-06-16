#!/bin/bash

pushd site
git pull
popd
make update

## apply eulenfunk respondd patch https://github.com/eulenfunk/firmware/raw/v2019.1.x/patches/fix-respondd-rsk.patch
site/patchfile="patches/fix-respondd-rsk.patch"
if ! patch -R -p1 -s -f --ignore-whitespace --dry-run < $patchfile; then
  patch -p1 --ignore-whitespace < $patchfile
fi
grep 'ff02:'  package/gluon-respondd/files/etc/init.d/gluon-respondd

## build firmware images
branch="stable"             # Möglichkeiten sind: stable beta experimental
release="2020.1.3-rdv-2.2"

cores=$(($(nproc) + 1))

make -j$cores GLUON_TARGET=ar71xx-generic GLUON_BRANCH=$branch DEFAULT_GLUON_RELEASE=$release
make -j$cores GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=$branch DEFAULT_GLUON_RELEASE=$release
# make -j$cores GLUON_TARGET=ar71xx-nand GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=brcm2708-bcm2708 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=brcm2708-bcm2709 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=mpc85xx-p1020 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=ramips-mt7621 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=sunxi-cortexa7 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=x86-generic GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=x86-geode GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=x86-64 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=ipq40xx GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=ramips-mt7620 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=ramips-mt76x8 GLUON_BRANCH=$branch
# make -j$cores GLUON_TARGET=ramips-rt305x GLUON_BRANCH=$branch
