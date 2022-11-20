#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

snes_config_dir="/opt/retropie/configs/snes"
log_file="$SCRIPT_DIR/PiSnesChangeConfByJoystickId.log"

snes_config="snes9x.cfg"
snes_s_x="snes9x-SNES1_XBOX2.cfg"
snes_x_s="snes9x-XBOX1_SNES2.cfg"
snes_s_s="snes9x-SNES1_SNES2.cfg"


SUBSTRING_SNES="usb_gamepad-joystick"
SUBSTRING_XBOX="Logitech"

#Bkp and reseting log file
cp -v $log_file $log_file.bkp 2>/dev/null || :
echo "" > $log_file

logInfo(){
	
	DT=$(date)
	echo "$DT: $1" >> $log_file
}


getJSId(){
	JS_ID=$(ls -lirth /dev/input/by-id/ | grep /$1 | cut -f10 -d" ")
	echo $JS_ID
}

logInfo "[Start: Changing Configuration SNES (PiSnes)]"
JS0=$(getJSId js0)
JS1=$(getJSId js1)

logInfo "[JS0: $JS0]"
logInfo "[JS1: $JS1]"


if [[ "$JS0" == *"$SUBSTRING_SNES"* ]] && [[ "$JS1" == *"$SUBSTRING_XBOX"* ]]; then
	logInfo "SNES=0 XBOX=1"
	cpLog=$(cp -v $snes_config_dir/$snes_s_x $snes_config_dir/$snes_config)
elif [[ "$JS0" == *"$SUBSTRING_XBOX"* ]] && [[ "$JS1" == *"$SUBSTRING_SNES"* ]]; then
	logInfo "XBOX=0 SNES=1"
	cpLog=$(cp -v $snes_config_dir/$snes_x_s $snes_config_dir/$snes_config)
elif [[ "$JS0" == *"$SUBSTRING_SNES"* ]] && [[ "$JS1" == *"$SUBSTRING_SNES"* ]]; then
	logInfo "SNES=0 SNES=1"
	cpLog=$(cp -v $snes_config_dir/$snes_s_s $snes_config_dir/$snes_config)
elif [[ "$JS0" == *"$SUBSTRING_SNES"* ]] && [[ "$JS1" == "" ]]; then
	logInfo "SNES=0"
	cpLog=$(cp -v $snes_config_dir/$snes_s_x $snes_config_dir/$snes_config)
elif [[ "$JS0" == *"$SUBSTRING_XBOX"* ]] && [[ "$JS1" == "" ]]; then
	logInfo "XBOX=0"
	cpLog=$(cp -v $snes_config_dir/$snes_x_s $snes_config_dir/$snes_config)
elif [[ "$JS0" == "" ]] && [[ "$JS1" == *"$SUBSTRING_SNES"* ]]; then
	logInfo "SNES=1"
	cpLog=$(cp -v $snes_config_dir/$snes_s_x $snes_config_dir/$snes_config)
elif [[ "$JS0" == "" ]] && [[ "$JS1" == *"$SUBSTRING_XBOX"* ]]; then
	logInfo "XBOX=1"
	cpLog=$(cp -v $snes_config_dir/$snes_s_x $snes_config_dir/$snes_config)
else
	logInfo "No Joystick identified"
fi

logInfo "[Finish: Changing Configuration SNES (PiSnes)]"

cat $log_file