#!/bin/bash

ar1100=$(dmesg | grep "input: Microchip Technology Inc. AR1100")

echo $ar1100
if [ -z "$ar1100" ]
then
      echo "\$no ar1100 defaul events are used"
      ./home/epilog/ebt-ui/ebtUi -platform eglfs 2>& 1 | tee -a /home/epilog/ebt-ui/output.log > /dev/null 2>& 1

else
      echo "\$ar1100 is found. Related input device is used"
      inputDeviceNumber=${ar1100: -1}
      echo $inputDeviceNumber
      #./home/epilog/ebt-ui/VideoQMLJnano -platform eglfs -plugin evdevmouse:/dev/input/event"$inputDeviceNumber":abs 2>& 1 | tee /home/epilog/ebt-ui/output.log > /dev/null 2>& 1
      ./home/epilog/ebt-ui/ebtUi -platform eglfs 2>& 1 | tee -a /home/epilog/ebt-ui/output.log > /dev/null 2>& 1
fi


