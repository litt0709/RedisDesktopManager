#!/bin/bash

# prerequired: 
# run ./brew install qt
# run ./brew install openssl cmake python3
# run with sudo command

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo '=======================Clone RDM repository======================='
git clone --recursive https://github.com/litt0709/RedisDesktopManager.git rdm
chmod -R 777 $SHELL_FOLDER/rdm

echo "=======================Switch to latest tag: ${TAG}===================="
cd $SHELL_FOLDER/rdm
#TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
TAG='2019Build'
echo 'switch to latest tag: '$TAG
cd $SHELL_FOLDER/rdm
git checkout -b $TAG $TAG

echo '=======================Modify RDM version======================='
cd $SHELL_FOLDER/rdm/src/resources
echo 'copy Info.plist'
cp Info.plist.sample Info.plist
echo 'modify Info.plist'
sed -i '' 's/0.0.0/$TAG/g' Info.plist

echo '=======================Install Python requirements======================='
mkdir -p $SHELL_FOLDER/rdm/bin/osx/release
cd $SHELL_FOLDER/rdm/bin/osx/release
touch setup.cfg
/bin/cat <<EOM >setup.cfg
[install]
prefix=
EOM
pip3 install -t ./ -r ../../../src/py/requirements.txt --upgrade

echo "=======================Build RDM ${TAG}======================="
cd $SHELL_FOLDER/rdm/src
qmake CONFIG-=debug CONFIG+=sdk_no_version_check
make -s -j 8

echo "=======================Copy QT Framework(optional)======================="
cd $SHELL_FOLDER/rdm/bin/osx/release
macdeployqt Redis\ Desktop\ Manager.app -qmldir=../../../src/qml

echo "=======================SUCCESS======================="
echo 'App file is:'$SHELL_FOLDER/rdm/bin/osx/release/Redis\ Desktop\ Manager.app.app