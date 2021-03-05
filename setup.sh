#!/bin/bash

# requirements
# width
# height
# refresh_rate
# position
# password
    echo
    echo "/////////////////////////////////////////////"
    echo "//                                         //"
    echo "//          screen-extensio                //"
    echo "//                                        //"
    echo "///////////////////////////////////////////"
    echo 

echo "-----------------------"
echo " Running check-pkg.sh "
echo "-----------------------"
sudo ./check-pkg.sh
echo 

while true; do
    read -p 'Display width: ' width
    read -p 'Display height: ' height
    read -p 'refresh_rate: ' refresh_rate
    read -p 'Choose the position of your new monitor (0 for right, 1 for left, 2 for bottom, 3 for top):  ' position
    while true; do
        read -sp 'Password: ' password
        echo 
        read -sp "Confirm Password: " confirm_pass
        echo 
        if [ ${password} != ${confirm_pass} ]; then
           echo " xxxx Password doesnt match xxxx "
        else
            break
        fi
    done
    echo "---------------------------------------"
    read -p "Please confirm your answers by entering 'Y' or 'n': " confirm
    if [ "${confirm}" == 'Y' ]; 
    then 
        break
    else
        echo " zzzzz try again zzzzz "
        continue
    fi
done

modeline=$(gtf ${width} ${height} ${refresh_rate} | sed -n '3 p'| sed 's/  Modeline//')
resolution=${width}x${height}_${refresh_rate}.00
positions=('--right-of' '--left-of' '--below' '--top')
current_output=$(xrandr --listmonitors | awk '{print $4}'| awk 'NR==2{print $1}')
user_path=/home/$(whoami)

echo "Creating folder for 'vnc'.."
mkdir ~/.vnc
echo

echo "Saving your password..."
x11vnc -storepasswd ${password} ~/.vnc/password

# create app folder
echo "creating folder '~/.screen-extensio'"
mkdir ~/.screen-extensio
echo

# create app start executable
echo "creating startvnc executable '~/.screen-extensio/startvnc.sh'" 
touch ~/.screen-extensio/startvnc.sh
cat > ~/.screen-extensio/startvnc.sh <<EOL
#!/bin/bash
xrandr --newmode ${modeline}
xrandr --addmode VIRTUAL1 ${resolution}
xrandr --output VIRTUAL1 --mode ${resolution} ${positions[${position}]} ${current_output}
adb reverse tcp:5900 tcp:5900

x11vnc -usepw -clip ${width}x${height}+0+0

echo "Please enter the following details in your VNC app-"    
echo      "      1) IP Address: localhost "
echo      "      2) VNC Password: "    
echo      "      3) Port (optional): 5900"   
echo "Run program 'Close VNC' to close vnc"

EOL
echo 

# creat app close executable
echo "creating close vnc executable '~/.screen-extensio/closevnc.sh'"

cat > ~/.screen-extensio/closevnc.sh <<EOL
#!/bin/bash
adb kill-server
killall x11vnc
xrandr --output VIRTUAL1 --off
xrandr --delmode VIRTUAL1 "${width}x${height}_${refresh_rate}.00"
xrandr --rmmode "${width}x${height}_${refresh_rate}.00"

EOL
echo 

# creating desktop shortcut for startvnc.sh
echo "creating startvnc shortcut '~/.local/share/applications/startvnc.desktop'"

cat > ~/.local/share/applications/startvnc.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=true
Exec=${user_path}/.screen-extensio/startvnc.sh
Name=Start VNC
Icon=cs-screen

EOL
echo

# creating closevnc shortcut
echo "creating closevnc shortcut '~/.local/share/applications/closevnc.desktop'"

cat > ~/.local/share/applications/closevnc.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=true
Exec=${user_path}/.screen-extensio/closevnc.sh
Name=Close VNC
Icon=cs-screen

EOL
echo 

# making scripts executable
echo " Making scripts 'startvnc.sh' 'closevnc.sh' 'startvnc.desktop' 'closevnc.desktop' 'uninstall.sh' executable"

sudo chmod +x ~/.screen-extensio/startvnc.sh ~/.screen-extensio/closevnc.sh ~/.local/share/applications/startvnc.desktop ~/.local/share/applications/closevnc.desktop uninstall.sh

echo 'application setup complete.'
echo '++++ You can now run the program named "Start VNC" to start the vnc server! ++++'
echo
echo '!!! note that you have to connect your android device and enable usb-debugging before continuing...' 
echo 'Make sure that both the devices are connected to the same network! Please enable USB-Tethering for faster performance...!!!' 
echo
echo "---- You can stop the vnc by running the program 'Close VNC'! ----" 

