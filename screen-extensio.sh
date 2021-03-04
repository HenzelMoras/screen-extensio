#!/bin/bash

# requirements
# width
# height
# refresh_rate
# position
# password
while true; do
    read -p 'width: ' width
    read -p 'height: ' height
    read -p 'refresh_rate: ' refresh_rate
    read -p 'position: ' position
    while true; do
        read -sp 'Password: ' password
        echo 
        read -sp "Choose the position of your new monitor (0 for right, 1 for left, 2 for bottom, 3 for top): " confirm_pass
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

modeline=$(gtf ${width} ${height} ${refresh_rate} | grep -E "Modeline")
resolution=$(echo $modeline | grep -o ""${width}x${height}_${refresh_rate}.00"")
positions=['--right-of' '--left-of' '--below' '--top']
current_output=$(xrandr --listmonitors | awk '{print $4}'| awk 'NR==2{print $1}')


echo "Creating folder for 'vnc'.."
mkdir ~/.vnc

echo

echo "Saving your password..."
x11vnc -storepasswd ${password} ~/.vnc/password

# create app folder
mkdir ~/.screen-extensio

# create app start executable
cat > ~/.screen-extensio/startvnc.sh <<EOL
#!/bin/bash
xrandr --newmode ${modeline}
xrandr --addmode VIRTUAL1 ${resolution}
xrandr --output VIRTUAL1 --mode ${resolution} ${positions[${position}]} ${current_output}
adb reverse tcp:5900 tcp:5900

x11vnc -usepw -clip ${width}+${height}+0+0

echo "Please enter the following details in your VNC app-"    
echo      "      1) IP Address: localhost "
echo      "      2) VNC Password: "    
echo      "      3) Port (optional): 5900"   
echo "Execute 'Close VNC' to close vnc"

EOL

# creat app close executable
cat > ~/.screen-extensio/closevnc.sh <<EOL
#!/bin/bash
killall x11vnc
xrandr --output VIRTUAL1 --off

EOL



