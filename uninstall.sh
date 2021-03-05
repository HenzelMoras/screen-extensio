#!/bin/bash
read -p 'Do you really want to uninstall the script? (y/n): ' x
if [ $x = 'y' ]; then
  echo 'Uninstalling script...'
  rm -r ~/.screen-extensio > /dev/null 2>&1
  rm ~/.local/share/applications/startvnc.desktop > /dev/null 2>&1
  rm ~/.local/share/applications/closevnc.desktop > /dev/null 2>&1
  rm -r ~/.vnc > /dev/null 2>&1
  sudo rm /usr/share/X11/xorg.conf.d/20-intel.conf
  echo 'Uninstalled successfully!'
else
  echo 'Uninstall was aborted.'
fi