# Industrial User Interface Example for Python Visual AI Applications with Qt

In this repository you can find that the User Interface to manage hardware configurations and draw related objects with Qt and QML for Python AI visual applications.

Block Diagram:

<img src="https://github.com/PhysicsX/UI-Example-for-Python-AI-applications-with-Qt/blob/master/BlockDiagram.png?raw=true" width="250">

Looks like:

![](https://github.com/PhysicsX/UI-Example-for-Python-AI-applications-with-Qt/blob/master/demo.gif)

## Installation

Qt should be installed in the target. Reference Qt version is 5.15.0. 
Tested with ubuntu 18 and 20.

clone the repo

```bash
git clone https://github.com/PhysicsX/UI-Example-for-Python-AI-applications-with-Qt.git
```

If you do not want to build manually, just run.

```bash
$ sudo bash
# cd scripts
# bash buildQt.sh
```
Then skip manual build section.
If you want to build it manually, follow the steps:

```bash
$ sudo bash
# apt update
# apt upgrade -y
```
After upgrading, necessary graphics dependencies is installed to enable eglfs and opengl es.

Some dependencies should be installed also:
```bash
# apt install '.*libxcb.*' libxrender-dev libxi-dev libfontconfig1-dev libudev-dev libgles2-mesa-dev libgl1-mesa-dev gcc git bison python gperf pkg-config make libclang-dev build-essential libssl-dev
```
Then first we simply install qtbase and other necessary modules:

* qtbase-everywhere-src-5.15.0.tar.xz
* qtdeclarative-everywhere-src-5.15.0.tar.xz
* qtquickcontrols-everywhere-src-5.15.0.tar.xz
* qtquickcontrols2-everywhere-src-5.15.0.tar.xz
* qtmultimedia-everywhere-src-5.15.0.tar.xz
* qtsvg-everywhere-src-5.15.0.tar.xz
* qtvirtualkeyboard-everywhere-src-5.15.0.tar.xz


These all can be installed from Qt official website.
```bash
# wget https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtbase-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtdeclarative-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtquickcontrols-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtquickcontrols2-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtmultimedia-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtsvg-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtvirtualkeyboard-everywhere-src-5.15.0.tar.xz https://download.qt.io/archive/qt/5.15/5.15.0/submodules/qtgraphicaleffects-everywhere-src-5.15.0.tar.xz
```

All modules should be built individually in an order.
For qtbase:
```bash
# tar xf qtbase-everywhere-src-5.15.0.tar.xz
# cd qtbase-everywhere-src-5.15.0
# ./configure -opengl es2 -opensource -confirm-license -force-debug-info -openssl-linked -nomake examples -nomake tests -v
# make -j8
# make install
# export QT_SELECT=5
```

After this qmake will be in the /usr/local/Qt-5.15.0/bin/qmake. This path can be changed with -prefix command. Modules which are built with this qmake will be stay in the path.

Configuration parameters should be like this:

```
Configure summary:

Build type: linux-g++ (arm64, CPU features: neon)
Compiler: gcc 7.5.0
Configuration: compile_examples enable_new_dtags force_debug_info largefile neon precompile_header shared shared rpath release c++11 c++14 c++17 c++1z concurrent dbus reduce_exports stl
Build options:
  Mode ................................... release (with debug info)
  Optimize release build for size ........ no
  Building shared libraries .............. yes
  Using C standard ....................... C11
  Using C++ standard ..................... C++17
  Using ccache ........................... no
  Using new DTAGS ........................ yes
  Generating GDB index ................... no
  Relocatable ............................ yes
  Using precompiled headers .............. yes
  Using LTCG ............................. no
  Target compiler supports:
    NEON ................................. yes
  Build parts ............................ libs tools
Qt modules and options:
  Qt Concurrent .......................... yes
  Qt D-Bus ............................... yes
  Qt D-Bus directly linked to libdbus .... no
  Qt Gui ................................. yes
  Qt Network ............................. yes
  Qt Sql ................................. yes
  Qt Testlib ............................. yes
  Qt Widgets ............................. yes
  Qt Xml ................................. yes
Support enabled for:
  Using pkg-config ....................... yes
  udev ................................... yes
  Using system zlib ...................... yes
  Zstandard support ...................... no
Qt Core:
  DoubleConversion ....................... yes
    Using system DoubleConversion ........ no
  GLib ................................... yes
  iconv .................................. no
  ICU .................................... yes
  Built-in copy of the MIME database ..... yes
  Tracing backend ........................ <none>
  Logging backends:
    journald ............................. no
    syslog ............................... no
    slog2 ................................ no
  PCRE2 .................................. yes
    Using system PCRE2 ................... no
Qt Network:
  getifaddrs() ........................... yes
  IPv6 ifname ............................ yes
  libproxy ............................... no
  Linux AF_NETLINK ....................... yes
  OpenSSL ................................ yes
    Qt directly linked to OpenSSL ........ yes
  OpenSSL 1.1 ............................ yes
  DTLS ................................... yes
  OCSP-stapling .......................... yes
  SCTP ................................... no
  Use system proxies ..................... yes
  GSSAPI ................................. no
Qt Gui:
  Accessibility .......................... yes
  FreeType ............................... yes
    Using system FreeType ................ yes
  HarfBuzz ............................... yes
    Using system HarfBuzz ................ yes
  Fontconfig ............................. yes
  Image formats:
    GIF .................................. yes
    ICO .................................. yes
    JPEG ................................. yes
      Using system libjpeg ............... no
    PNG .................................. yes
      Using system libpng ................ yes
  Text formats:
    HtmlParser ........................... yes
    CssParser ............................ yes
    OdfWriter ............................ yes
    MarkdownReader ....................... yes
      Using system libmd4c ............... no
    MarkdownWriter ....................... yes
  EGL .................................... yes
  OpenVG ................................. no
  OpenGL:
    Desktop OpenGL ....................... no
    OpenGL ES 2.0 ........................ yes
    OpenGL ES 3.0 ........................ yes
    OpenGL ES 3.1 ........................ yes
    OpenGL ES 3.2 ........................ yes
  Vulkan ................................. no
  Session Management ..................... yes
Features used by QPA backends:
  evdev .................................. yes
  libinput ............................... no
  INTEGRITY HID .......................... no
  mtdev .................................. no
  tslib .................................. no
  xkbcommon .............................. no
  X11 specific:
    XLib ................................. yes
    XCB Xlib ............................. yes
    EGL on X11 ........................... yes
    xkbcommon-x11 ........................ no
QPA backends:
  DirectFB ............................... no
  EGLFS .................................. yes
  EGLFS details:
    EGLFS OpenWFD ........................ no
    EGLFS i.Mx6 .......................... no
    EGLFS i.Mx6 Wayland .................. no
    EGLFS RCAR ........................... no
    EGLFS EGLDevice ...................... yes
    EGLFS GBM ............................ no
    EGLFS VSP2 ........................... no
    EGLFS Mali ........................... no
    EGLFS Raspberry Pi ................... no
    EGLFS X11 ............................ yes
  LinuxFB ................................ yes
  VNC .................................... yes
Qt Sql:
  SQL item models ........................ yes
Qt Widgets:
  GTK+ ................................... no
  Styles ................................. Fusion Windows
Qt PrintSupport:
  CUPS ................................... no
Qt Sql Drivers:
  DB2 (IBM) .............................. no
  InterBase .............................. no
  MySql .................................. no
  OCI (Oracle) ........................... no
  ODBC ................................... no
  PostgreSQL ............................. no
  SQLite2 ................................ no
  SQLite ................................. yes
    Using system provided SQLite ......... no
  TDS (Sybase) ........................... no
Qt Testlib:
  Tester for item models ................. yes

Note: Also available for Linux: linux-clang linux-icc

Note: When linking against OpenSSL, you can override the default
library names through OPENSSL_LIBS.
For example:
    OPENSSL_LIBS='-L/opt/ssl/lib -lssl -lcrypto' ./configure -openssl-linked

Qt is now configured for building. Just run 'make'.
Once everything is built, you must run 'make install'.
Qt will be installed into '/usr/local/Qt-5.15.0'.

Prior to reconfiguration, make sure you remove any leftovers from
the previous build.

```

Now we can install submodules.
For qtdeclarative:
```bash
# cd ..
# tar xf qtdeclarative-everywhere-src-5.15.0.tar.xz
# cd qtdeclarative-everywhere-src-5.15.0
# /usr/local/QtEpilog/bin/qmake
# make -j8
# make install
```
For qtquickcontrols:
```bash
# cd ..
# tar xf qtquickcontrols-everywhere-src-5.15.0.tar.xz
# cd qtquickcontrols-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```
For qtquickcontrols2:
```bash
# cd ..
# tar xf qtquickcontrols2-everywhere-src-5.15.0.tar.xz
# cd qtquickcontrols2-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```
For qtmultimedia:
```bash
# cd ..
# tar xf qtmultimedia-everywhere-src-5.15.0.tar.xz
# cd qtmultimedia-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```
For qtsvg: ( this one is needed for qtvirtualkeyboard)
```bash
# cd ..
# tar xf qtsvg-everywhere-src-5.15.0.tar.xz
# cd qtsvg-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```
For qtVirtualKeyboard:
```bash
# cd ..
# tar xf qtvirtualkeyboard-everywhere-src-5.15.0.tar.xz
# cd qtvirtualkeyboard-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```
For qtGraphicalEffects:
```bash
# cd ..
# tar xf qtgraphicaleffects-everywhere-src-5.15.0.tar.xz
# cd qtgraphicaleffects-everywhere-src-5.15.0
# /usr/local/Qt-5.15.0/bin/qmake
# make -j8
# make install
```

## How to test the application

Example is tested in jetson nano/nx.
Opencv should be installed/compiled with gstreamer option enabled.

![](https://www.uctronics.com/media/catalog/product/cache/5d1f08909b337dbf64263212361f58e9/i/m/imx219_ff_ir_nano_4.jpg)

Now you are ready to run the app. Picamera should be connected. Be sure to type "sudo bash".
```
# cd scripts
# bash run.sh
```

Then for the facedetection application:
```bash
# cd scripts
# python3 faceDetectionShm.py
```

### Citation

Ulas Dikme (2021). *Industrial user interface software design for visual
python AI applications using embedded linux based systems*. Journal of Applied and Physical Sciences, 7(1), 1-10. [10.20474/japs-7.1](https://doi.org/10.20474/japs-7.1)

