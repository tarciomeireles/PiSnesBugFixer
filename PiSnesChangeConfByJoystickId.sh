#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
snes_config_dir="/opt/retropie/configs/snes"
log_file="$SCRIPT_DIR/PiSnesChangeConfByJoystickId.log"

snes_config="snes9x.cfg"
snes_partial_config_keyboard="snes_partial_config_keyboard.cfg"
snes_partial_config_joystickinit="snes_partial_config_joystickinit.cfg"
snes_partial_config_graphics="snes_partial_config_graphics.cfg"


#Bkp and reseting log file
cp -v $log_file $log_file.bkp 2>/dev/null || :
echo "" > $log_file

logInfo(){	
	DT=$(date)
	echo "$DT: $1" >> $log_file
}

getJSId(){
	JOYSTICK_ID=$(ls -lirth /dev/input/by-id/ | grep /$1 | cut -f10 -d" ")
	echo $JOYSTICK_ID
}


JOYSTICK_DEVICE_LIST=$(ls -t /dev/input/js* 2> /dev/null | sort | xargs -n 1 basename 2> /dev/null)

logInfo "[Start: Changing Configuration SNES (PiSnes)]"

if [ $(echo "$JOYSTICK_DEVICE_LIST" | wc -w)  -gt 0 ]
then
	
	#RESET CONFIGURATION FILE
	DT=$(date)
	echo "#FILE DYNAMICALLY BUILD BY $SCRIPT_DIR/PiSnesChangeConfByJoystickId.sh $DT " > $snes_config_dir/$snes_config
	echo "#TO CONFIGURE CHANGE THE FILES: $snes_config_dir/$snes_partial_config_keyboard " >> $snes_config_dir/$snes_config
	echo "#                             : $snes_config_dir/$snes_partial_config_joystickinit " >> $snes_config_dir/$snes_config
	echo "#                             : $snes_config_dir/$snes_partial_config_graphics " >> $snes_config_dir/$snes_config
	echo "#                             : $snes_config_dir/<JOYSTICK_ID> " >> $snes_config_dir/$snes_config
	echo "#TO FIND <JOYSTICK_ID> USE 'ls -l /dev/input/by-id/ | grep js' WHEN THE JOYSTICK IS CONNECTED " >> $snes_config_dir/$snes_config
	
	cat $snes_config_dir/$snes_partial_config_keyboard >> $snes_config_dir/$snes_config
	cat $snes_config_dir/$snes_partial_config_joystickinit >> $snes_config_dir/$snes_config
	
	for JOYSTICK_DEVICE in $JOYSTICK_DEVICE_LIST # -t = orded by time |  xargs -n 1 basename =  only show file name
	do 
		JOYSTICK_ID=$(getJSId $JOYSTICK_DEVICE) # Examples:  usb-Logitech_Gamepad_F310_F1BB2997-joystick, usb-0810_usb_gamepad-joystick
		JOYSTICK_DEV_NUMBER=$(echo $JOYSTICK_DEVICE | cut -b3) # For js0=0, js1=1
		let "JOYSTICK_POSITION=JOYSTICK_DEV_NUMBER+1" #js0 -> Position = 1,  js1 -> Position = 2
		config_message="#>>>>>> CONFIGURATION OF /etc/input/$JOYSTICK_DEVICE CONNECTED TO $JOYSTICK_ID AT POSITION $JOYSTICK_POSITION"
		echo $config_message >> $snes_config_dir/$snes_config
		cat $snes_config_dir/$JOYSTICK_ID.cfg | sed "s/<JOYSTICK_POSITION>/$JOYSTICK_POSITION/g" >> $snes_config_dir/$snes_config
		
		logInfo "$config_message"
	done
	
	cat $snes_config_dir/$snes_partial_config_graphics >> $snes_config_dir/$snes_config
else
	logInfo "No Joystick identified, Nothing done"
fi
logInfo "[Finish: Changing Configuration SNES (PiSnes)]"





