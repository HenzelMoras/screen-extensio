#! /bin/bash

# 1. istall necessary packages
echo
echo " updating sysytem package list"
echo
echo  
sudo apt update -y

echo 

pkg_req=('x11vnc' 'adb' 'android-tools-adb' 'android-tools-fastboot')

echo " checking required packages"
check_pkg_exists(){
    for package in "${pkg_req[@]}"
    do
        pkg_check=$(dpkg --list | grep -o "$package")
        echo      # newline 
        echo ".....checking package : $package....."
        
        if [ "" = "${pkg_check}" ]; then
            echo " Installing package please wait..."
            echo
            sudo apt -y install $package
            echo " installed: $package" 
        else
            echo "package already exists"
        fi
    done

}
check_pkg_exists

if [ -e /usr/share/X11/xorg.conf.d/20-intel.conf ]
then
    echo
    echo "++++++++++++++++++++++++++++++"
    echo " +++++proceeding further+++++ "
    echo "++++++++++++++++++++++++++++++"
    echo
    echo " the intel file for virtualheads exists continuing... "
    echo
    echo "------------------------"
    echo " running setup.sh "
    echo "------------------------"
else
  cp 20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf
  echo 
  echo "[screen-extensio]" 
  echo "-------------You must" 
  echo "---------------------reboot or relogin" 
  echo "-------------current session" 
  echo "to finish setup run screen-extensio.sh "
  read -p " Enter Y/n to proceed: " ans
  
  if [ "Y" == "${ans}" ]; then
     echo " ...rebooting... "
     sudo reboot now
  else
      echo " exiting"
      exit
  fi
  
fi
echo

    

