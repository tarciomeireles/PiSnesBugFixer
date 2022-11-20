#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

log_file="$SCRIPT_DIR/TestEventLogitech.log"

#Bkp and reseting log file
cp -v $log_file $log_file.bkp 2>/dev/null || :
echo "" > $log_file

logInfo(){
	DT=$(date)
	echo "$DT: $1" >> $log_file
}


logInfo "TESTE DE EVENTO DO BOTAO CENTRAL LOGITECH (XBOX)"

#Só funciona no modo X (switch abeixo do controle) Mas ainda está com alguma dificuldade de funcionar no jslisten (nao acarreta problemas)