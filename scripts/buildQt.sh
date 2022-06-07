#!/bin/bash
#
# Automated build process for ebt-ui 
# This is not suitable for cross development activity


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

cd $HOME

export DEBIAN_FRONTEND=noninteractive

echo
echo "############################"
echo "Starting apt-get-update"
date
echo
apt-get update
apt-get upgrade -y

apt install -y '.*libxcb.*' libxrender-dev libxi-dev libfontconfig1-dev libudev-dev libgles2-mesa-dev libgl1-mesa-dev gcc git bison python gperf pkg-config make libclang-dev build-essential libssl-dev libpcre2-16-0 wmctrl

echo "Installing qtbase and modules"

mainVersion="5.15"
subVersion=".0"

concVersion="$mainVersion$subVersion"

qtbaseFile="qtbase-everywhere-src-$concVersion"
qtbaseXZ="$qtbaseFile.tar.xz"
qtbase="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtbaseXZ"


echo $concVersion

if [ -f "$HOME/$qtbaseXZ" ]; then
    echo "qtbase-everywhere-src-$concVersion exists."
else 
    echo "$concVersion does not exist."
	wget $qtbase
fi

qtdeclarativeFile="qtdeclarative-everywhere-src-$concVersion"
qtdeclarativeXZ="$qtdeclarativeFile.tar.xz"
qtdeclarative="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtdeclarativeXZ"

rm -rf qtdeclarativeFile
if [ -f "$HOME/$qtdeclarativeXZ" ]; then
    echo "qtbase-everywhere-src-$concVersion exists."
else 
    echo "$concVersion does not exist."
	wget $qtdeclarative
fi


qtquickcontrolsFile="qtquickcontrols-everywhere-src-$concVersion"
qtquickcontrolsXZ="$qtquickcontrolsFile.tar.xz"
qtquickcontrols="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtquickcontrolsXZ"

rm -rf qtquickcontrolsFile
if [ -f "$HOME/$qtquickcontrolsXZ" ]; then
    echo "$qtquickcontrolsXZ exists."
else 
    echo "$qtquickcontrolsXZ does not exist."
	wget $qtquickcontrols
fi

qtquickcontrols2File="qtquickcontrols2-everywhere-src-$concVersion"
qtquickcontrols2XZ="$qtquickcontrols2File.tar.xz"
qtquickcontrols2="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtquickcontrols2XZ"

rm -rf qtquickcontrols2File
if [ -f "$HOME/$qtquickcontrols2XZ" ]; then
    echo "$qtquickcontrols2XZ exists."
else 
    echo "$qtquickcontrols2XZ does not exist."
	wget $qtquickcontrols2
fi

qtmultimediaFile="qtmultimedia-everywhere-src-$concVersion"
qtmultimediaXZ="$qtmultimediaFile.tar.xz"
qtmultimedia="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtmultimediaXZ"

rm -rf qtmultimediaFile
if [ -f "$HOME/$qtmultimediaXZ" ]; then
    echo "$qtmultimediaXZ exists."
else 
    echo "$qtmultimediaXZ does not exist."
	wget $qtmultimedia
fi


qtsvgFile="qtsvg-everywhere-src-$concVersion"
qtsvgXZ="$qtsvgFile.tar.xz"
qtsvg="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtsvgXZ"

rm -rf qtsvgFile
if [ -f "$HOME/$qtsvgXZ" ]; then
    echo "$qtsvgXZ exists."
else 
    echo "$qtsvgXZ does not exist."
	wget $qtsvg
fi

qtvirtualkeyboardFile="qtvirtualkeyboard-everywhere-src-$concVersion"
qtvirtualkeyboardXZ="$qtvirtualkeyboardFile.tar.xz"
qtvirtualkeyboard="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtvirtualkeyboardXZ"

rm -rf qtvirtualkeyboardFile
if [ -f "$HOME/$qtvirtualkeyboardXZ" ]; then
    echo "$qtvirtualkeyboardXZ exists."
else 
    echo "$qtvirtualkeyboardXZ does not exist."
	wget $qtvirtualkeyboard
fi


qtgraphicaleffectsFile="qtgraphicaleffects-everywhere-src-$concVersion"
qtgraphicaleffectsXZ="$qtgraphicaleffectsFile.tar.xz"
qtgraphicaleffects="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtgraphicaleffectsXZ"

rm -rf qtgraphicaleffectsFile
if [ -f "$HOME/$qtgraphicaleffectsXZ" ]; then
    echo "$qtgraphicaleffectsXZ exists."
else 
    echo "$qtgraphicaleffectsXZ does not exist."
	wget $qtgraphicaleffects
fi

qtwebsocketsFile="qtwebsockets-everywhere-src-$concVersion"
qtwebsocketsXZ="$qtwebsocketsFile.tar.xz"
qtwebsockets="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtwebsocketsXZ"

rm -rf qtwebsocketsFile
if [ -f "$HOME/$qtwebsocketsXZ" ]; then
    echo "$qtwebsocketsXZ exists."
else 
    echo "$qtwebsocketsXZ does not exist."
	wget $qtwebsockets
fi

qtwebglpluginFile="qtwebglplugin-everywhere-src-$concVersion"
qtwebglpluginXZ="$qtwebglpluginFile.tar.xz"
qtwebglplugin="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtwebglpluginXZ"

rm -rf qtwebglpluginFile
if [ -f "$HOME/$qtwebglpluginXZ" ]; then
    echo "$qtwebglpluginXZ exists."
else 
    echo "$qtwebglpluginXZ does not exist."
	wget $qtwebglplugin
fi

echo "Modules are installed built each one "
echo "qtbase "
sleep 1

DIR="/usr/local/QtEpilog/include/QtCore"
if [ -d "$DIR" ]; then

  echo "qtbase is exist ${DIR}..."
else
	tar xf $qtbaseXZ
	cd $HOME/$qtbaseFile
	./configure -opengl es2 -opensource -confirm-license -force-debug-info -prefix /usr/local/QtEpilog -nomake examples -nomake tests -v
	make -j8
	make install
	export QT_SELECT=5
	cd ..
fi

tar xf $qtdeclarativeXZ
cd $HOME/$qtdeclarativeFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtquickcontrolsXZ
cd $HOME/$qtquickcontrolsFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtquickcontrols2XZ
cd $HOME/$qtquickcontrols2File
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..
 
tar xf $HOME/$qtmultimediaXZ
cd $HOME/$qtmultimediaFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..
 
tar xf $HOME/$qtsvgXZ
cd $HOME/$qtsvgFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtvirtualkeyboardXZ
cd $HOME/$qtvirtualkeyboardFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtgraphicaleffectsXZ
cd $HOME/$qtgraphicaleffectsFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtwebsocketsXZ
cd $HOME/$qtwebsocketsFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtwebglpluginXZ
cd $HOME/$qtwebglpluginFile
/usr/local/QtEpilog/bin/qmake
make -j8
make install
cd ..

echo 'All Done!'

cd ~



