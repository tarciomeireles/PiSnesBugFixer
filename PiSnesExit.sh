#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

log_file="$SCRIPT_DIR/PiSnesExit.log"

#Bkp and reseting log file
cp -v $log_file $log_file.bkp 2>/dev/null || :
echo "" > $log_file

logInfo(){
	DT=$(date)
	echo "$DT: $1" >> $log_file
}

PID_SNES=$(ps ax | grep pisnes/snes9x | grep tty | cut -f2 -d" " )
if [[ "$PID_SNES" != "" ]]; then
	kill -9 $PID_SNES
	logInfo "Process SNES Terminated PID($PID_SNES)"
else
	logInfo "No process SNES finded, nothing done"
fi

#Temporally killing dosbox too
PID_DOSBOX=$(ps axf | grep dosbox | grep -v grep | awk '{print $1}')

if [[ "$PID_DOSBOX" != "" ]]; then
	kill -9 $PID_DOSBOX
	logInfo "Process Dosbox Terminated PID($PID_DOSBOX)"
else
	logInfo "No process Dosbox finded, nothing done"
fi

cat $log_file