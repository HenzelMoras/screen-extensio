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
            echo "package already exists continuing"
        fi
    done

}
check_pkg_exists
