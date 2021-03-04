#! /bin/bash

# 1. istall necessary packages
echo " updating sysytem package list"
echo
echo "   ----------   " 
sudo apt update -y

echo 

pkg_req=('x11vnc' 'adb' 'android-tools-adb' 'android-tools-fastboot')

echo " checking required packages"
check_pkg_exists(){
    for package in "${pkg_req[@]}"
    do
        pkg_check=$(dpkg --list | grep -o "$package")
        echo      # newline 
        echo ".....checking whether package is installed: $package....."
        
        if [ "" = "${pkg_check}" ]; then
            echo " Installing package please wait..."
            echo
            sudo apt-get -y install $package
            echo " installed: $package" 
        else
            echo "package already exists"
        fi
    done

}
check_pkg_exists

source vdl-monitor.conf
if [ -e /usr/share/X11/xorg.conf.d/20-intel.conf ]
then
    echo " the intel file for virtualheads exists "
    echo 
    echo " running virtual monitor setup "
    
    sudo ./setup.sh
else
  cp 20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf
  echo "[screen-extensio]" 
  echo "-------------You must" 
  echo "---------------------reboot or relogin" 
  echo "-------------current session" 
  echo "to finish setup then run setup.sh "
  
fi

    

