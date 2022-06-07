# ebtAR1100Calibrator
    Example program for calibrating the Microchip AR1100 
    sudo apt-get install git make g++ libusb-1.0-0-dev libgtk2.0-dev
    -make 
    -code will compile
    -sudo chmod +x AR1100
    
    Execution:
    You can calibrate with 4 or 25 points, 9 is the default
    switch the AR1100 to USB mouse mode
    sudo ./AR1100 -c 9 -m
    Calibrate and switch to mouse mode
    
    Debugging:
    If you want more debugging info you can compile the code with:
    make clean
    make DEBUG=1
