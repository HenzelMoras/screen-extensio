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
        read -sp 'Confirm password: ' confirm_pass
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