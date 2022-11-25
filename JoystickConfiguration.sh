#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


JS_DEVICE=$(dialog --stdout --menu 'Lista normal de um campo por linha' \
        0 0 10 $( ls -l /dev/input/by-id/* | grep js | cut -f6,5 -d"/"  | awk '{ print $3 " " $1}' | cut -f2 -d"/"))
		
jstest --event /dev/input/$JS_DEVICE | grep -m 1 "type 1, time .*, number .*, value 1" | read _ _ _ _ _ _ number _ _
echo " foi esse $number"
if [ "${number%%,*}" -eq 3 ]
then
    echo "You pressed the Y button."
else
    echo "You pressed a button other than Y."
fi
