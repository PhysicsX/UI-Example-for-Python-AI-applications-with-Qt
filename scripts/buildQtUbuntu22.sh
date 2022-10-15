#!/bin/bash
#
# Automated build process for ubuntu 
# This is not suitable for cross development activity

echo "----- Qt Build script for Ubuntu 22 04 ------"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo bash) " 
   exit 1
fi

WHEREAMI=$PWD
OUTPUT_FILE=$WHEREAMI/output.txt

if [ -f "$OUTPUT_FILE" ]; then
    echo "$OUTPUT_FILE exists deleting it"
    rm -rf $OUTPUT_FILE
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

apt-get install -y make build-essential libclang-dev ninja-build gcc git bison \
python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev \
libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev \
libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev \
libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev \
libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
libatspi2.0-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev wmctrl libgles2-mesa-dev git \
libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x \
gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
libwebsocketpp-dev libboost-all-dev nlohmann-json3-dev 

if [ $? -eq 0 ]; then
    echo OK
else
    exit 1
fi

echo "Installing qtbase and modules"
mainVersion="5.15"
subVersion=".6"

INSTALLDIR="/usr/local/Qt$mainVersion$subVersion"

concVersion="$mainVersion$subVersion"

#for 5.15.5 or more it should be opensource
openSource="opensource-"

# for olders it should be empty
# openSource=""

qtbaseFile="qtbase-everywhere-"$openSource"src-$concVersion"
qtbaseDir="qtbase-everywhere-src-$concVersion"

qtbaseXZ="$qtbaseFile.tar.xz"
qtbase="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtbaseXZ"


echo $concVersion

if [ -f "$HOME/$qtbaseXZ" ]; then
    echo "qtbase-everywhere-$openSource-src-$concVersion exists."
else 
    echo "$concVersion does not exist."
	wget $qtbase
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtbase is not found"
    exit 1
fi

qtdeclarativeFile="qtdeclarative-everywhere-"$openSource"src-$concVersion"
qtdeclarativeDir="qtdeclarative-everywhere-src-$concVersion"

qtdeclarativeXZ="$qtdeclarativeFile.tar.xz"
qtdeclarative="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtdeclarativeXZ"

rm -rf qtdeclarativeFile
if [ -f "$HOME/$qtdeclarativeXZ" ]; then
    echo "qtbase-everywhere-opensource-src-$concVersion exists."
else 
    echo "$concVersion does not exist."
	wget $qtdeclarative
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtdeclarative is not found"
    exit 1
fi

qtquickcontrolsFile="qtquickcontrols-everywhere-"$openSource"src-$concVersion"
qtquickcontrolsDir="qtquickcontrols-everywhere-src-$concVersion"

qtquickcontrolsXZ="$qtquickcontrolsFile.tar.xz"
qtquickcontrols="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtquickcontrolsXZ"

rm -rf qtquickcontrolsFile
if [ -f "$HOME/$qtquickcontrolsXZ" ]; then
    echo "$qtquickcontrolsXZ exists."
else 
    echo "$qtquickcontrolsXZ does not exist."
	wget $qtquickcontrols
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtquickcontrols is not found"
    exit 1
fi

qtquickcontrols2File="qtquickcontrols2-everywhere-"$openSource"src-$concVersion"
qtquickcontrols2Dir="qtquickcontrols2-everywhere-src-$concVersion"

qtquickcontrols2XZ="$qtquickcontrols2File.tar.xz"
qtquickcontrols2="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtquickcontrols2XZ"

rm -rf qtquickcontrols2File
if [ -f "$HOME/$qtquickcontrols2XZ" ]; then
    echo "$qtquickcontrols2XZ exists."
else 
    echo "$qtquickcontrols2XZ does not exist."
	wget $qtquickcontrols2
fi

qtmultimediaFile="qtmultimedia-everywhere-"$openSource"src-$concVersion"
qtmultimediaDir="qtmultimedia-everywhere-src-$concVersion"

qtmultimediaXZ="$qtmultimediaFile.tar.xz"
qtmultimedia="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtmultimediaXZ"

rm -rf qtmultimediaFile
if [ -f "$HOME/$qtmultimediaXZ" ]; then
    echo "$qtmultimediaXZ exists."
else 
    echo "$qtmultimediaXZ does not exist."
	wget $qtmultimedia
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtmultimedia is not found"
    exit 1
fi

qtsvgFile="qtsvg-everywhere-"$openSource"src-$concVersion"
qtsvgDir="qtsvg-everywhere-src-$concVersion"

qtsvgXZ="$qtsvgFile.tar.xz"
qtsvg="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtsvgXZ"

rm -rf qtsvgFile
if [ -f "$HOME/$qtsvgXZ" ]; then
    echo "$qtsvgXZ exists."
else 
    echo "$qtsvgXZ does not exist."
	wget $qtsvg
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtsvg is not found"
    exit 1
fi

qtvirtualkeyboardFile="qtvirtualkeyboard-everywhere-"$openSource"src-$concVersion"
qtvirtualkeyboardDir="qtvirtualkeyboard-everywhere-src-$concVersion"

qtvirtualkeyboardXZ="$qtvirtualkeyboardFile.tar.xz"
qtvirtualkeyboard="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtvirtualkeyboardXZ"

rm -rf qtvirtualkeyboardFile
if [ -f "$HOME/$qtvirtualkeyboardXZ" ]; then
    echo "$qtvirtualkeyboardXZ exists."
else 
    echo "$qtvirtualkeyboardXZ does not exist."
	wget $qtvirtualkeyboard
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtvirtualkeyboard is not found"
    exit 1
fi

qtgraphicaleffectsFile="qtgraphicaleffects-everywhere-"$openSource"src-$concVersion"
qtgraphicaleffectsDir="qtgraphicaleffects-everywhere-src-$concVersion"

qtgraphicaleffectsXZ="$qtgraphicaleffectsFile.tar.xz"
qtgraphicaleffects="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtgraphicaleffectsXZ"

rm -rf qtgraphicaleffectsFile
if [ -f "$HOME/$qtgraphicaleffectsXZ" ]; then
    echo "$qtgraphicaleffectsXZ exists."
else 
    echo "$qtgraphicaleffectsXZ does not exist."
	wget $qtgraphicaleffects
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtgraphicaleffects is not found"
    exit 1
fi

qtwebsocketsFile="qtwebsockets-everywhere-"$openSource"src-$concVersion"
qtwebsocketsDir="qtwebsockets-everywhere-src-$concVersion"

qtwebsocketsXZ="$qtwebsocketsFile.tar.xz"
qtwebsockets="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtwebsocketsXZ"

rm -rf qtwebsocketsFile
if [ -f "$HOME/$qtwebsocketsXZ" ]; then
    echo "$qtwebsocketsXZ exists."
else 
    echo "$qtwebsocketsXZ does not exist."
	wget $qtwebsockets
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtwebsockets is not found"
    exit 1
fi

qtwebglpluginFile="qtwebglplugin-everywhere-"$openSource"src-$concVersion"
qtwebglpluginDir="qtwebglplugin-everywhere-src-$concVersion"

qtwebglpluginXZ="$qtwebglpluginFile.tar.xz"
qtwebglplugin="https://download.qt.io/archive/qt/$mainVersion/$concVersion/submodules/$qtwebglpluginXZ"

rm -rf qtwebglpluginFile
if [ -f "$HOME/$qtwebglpluginXZ" ]; then
    echo "$qtwebglpluginXZ exists."
else 
    echo "$qtwebglpluginXZ does not exist."
	wget $qtwebglplugin
fi

if [ $? -eq 0 ]; then
    echo OK
else
    echo "Desired $qtwebglplugin is not found"
    exit 1
fi

echo "Modules are installed built each one "
echo "qtbase "
sleep 1


DIR="$INSTALLDIR/include/QtCore"


if [ -d "$DIR" ]; then

  echo "qtbase is exist ${DIR}..."
else
	tar xf $qtbaseXZ
	cd $HOME/$qtbaseDir
	./configure -opengl es2 -opensource -confirm-license -force-debug-info -prefix $INSTALLDIR -nomake examples -nomake tests -v |& tee -a $OUTPUT_FILE
	make -j8
	make install
	export QT_SELECT=5
	cd ..
fi

tar xf $qtdeclarativeXZ
cd $HOME/$qtdeclarativeDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..

tar xf $qtquickcontrolsXZ
cd $HOME/$qtquickcontrolsDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..

tar xf $qtquickcontrols2XZ
cd $HOME/$qtquickcontrols2Dir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..
 
tar xf $qtmultimediaXZ
cd $HOME/$qtmultimediaDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..
 
tar xf $qtsvgXZ
cd $HOME/$qtsvgDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..

tar xf $qtvirtualkeyboardXZ
cd $HOME/$qtvirtualkeyboardDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..

tar xf $qtgraphicaleffectsXZ
cd $HOME/$qtgraphicaleffectsDir
$INSTALLDIR/bin/qmake |& tee -a $OUTPUT_FILE
make -j8 |& tee -a $OUTPUT_FILE
make install
cd ..

tar xf $HOME/$qtwebsocketsXZ
cd $HOME/$qtwebsocketsDir
$INSTALLDIR/bin/qmake
make -j8
make install
cd ..

tar xf $HOME/$qtwebglpluginXZ
cd $HOME/$qtwebglpluginDir
$INSTALLDIR/bin/qmake
make -j8
make install
cd ..


if [ -f "$HOME/$qtbaseXZ" ]; then
    rm -rf $HOME/$qtbaseXZ
    rm -rf $HOME/$qtbaseDir
fi

if [ -f "$HOME/$qtdeclarativeXZ" ]; then
    rm -rf $HOME/$qtdeclarativeXZ
    rm -rf $HOME/$qtdeclarativeDir
fi

if [ -f "$HOME/$qtquickcontrolsXZ" ]; then
    rm -rf $HOME/$qtquickcontrolsXZ
    rm -rf $HOME/$qtquickcontrolsDir
fi

if [ -f "$HOME/$qtquickcontrols2XZ" ]; then
    rm -rf $HOME/$qtquickcontrols2XZ
    rm -rf $HOME/$qtquickcontrols2Dir
fi

if [ -f "$HOME/$qtmultimediaXZ" ]; then
    rm -rf $HOME/$qtmultimediaXZ
    rm -rf $HOME/$qtmultimediaDir
fi

if [ -f "$HOME/$qtsvgXZ" ]; then
    rm -rf $HOME/$qtsvgXZ
    rm -rf $HOME/$qtsvgDir
fi

if [ -f "$HOME/$qtvirtualkeyboardXZ" ]; then
    rm -rf $HOME/$qtvirtualkeyboardXZ
    rm -rf $HOME/$qtvirtualkeyboardDir
fi

if [ -f "$HOME/$qtgraphicaleffectsXZ" ]; then
    rm -rf $HOME/$qtgraphicaleffectsXZ
    rm -rf $HOME/$qtgraphicaleffectsDir
fi

if [ -f "$HOME/$qtwebsocketsXZ" ]; then
    rm -rf $HOME/$qtwebsocketsXZ
    rm -rf $HOME/$qtwebsocketsDir
fi

if [ -f "$HOME/$qtwebglpluginXZ" ]; then
    rm -rf $HOME/$qtwebglpluginXZ
    rm -rf $HOME/$qtwebglpluginDir
fi

echo 'All Done!'

cd ~
