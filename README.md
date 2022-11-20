# PiSnesBugFixer

## Index
 1. [Overview](#overview)
 2. [Installation](#installation)
 3. [Installation](#installation)

## Overview

Scripts para corrigir o bug que o emulador PiSNES não consegue sair pressionando START+SELECT quando o controle de XBOX (Logitech) é inserido junto com o Controle de Xbox no RaspberryPi RetroPie. Utiliza o daemon `jslisten` para dar o comando `kill -9 PID_SNES` e encerrar o emulador. Também muda a configuração de controles para XBOX=1 e SNES=2, SNES=1 e SNES=2, XBOX=1 e XBOX=2, SNES=1 e XBOX=2, conforme a ordem dos controles forem inseridos no Raspberry, pois o emulador se perde na configuração dado que os botões são diferentes no `jstest /dev/input/js[*]`  


## Installation

### Quick Install

- Instalar o jslisten conforme indicado no site: https://github.com/workinghard/jslisten 
- Copiar os scripts para /home/pi/Misc/PiSnesBugFixer
- Dar permissão de execução para os scripts .sh
- Copiar os scripts /home/pi/Misc/PiSnesBugFixer/bkpConfigs/*.cfg para /opt/retropie/configs/snes (e ajustá-los se necessário)
- Modificar a seguinte linha no arquivo /opt/retropie/configs/snes/emulators.cfg
	- `pisnes = "/home/pi/Misc/PiSnesBugFixer/PiSnesChangeConfByJoystickId.sh; /opt/retropie/emulators/pisnes/snes9x %ROM%"`
- Copiar o arquivo /home/pi/Misc/PiSnesBugFixer/.jslisten para /home/pi/.jslisten


## Dicas
- O tipo de funcionamento do controle de XBOX (switch abaixo do controle entre D e X, modifica o comportamento do controle.
- Os testes foram feitos com o padrão D
- modo D (jstest /dev/input/js0 (quando Xbox está no 0)):
	- Joystick (Logitech Logitech Dual Action) has 6 axes (X, Y, Z, Rz, Hat0X, Hat0Y) and 12 buttons
- modo X (jstest /dev/input/js0 (quando Xbox está no 0)):
	- Joystick (Logitech Gamepad F310) has 6 axes (X, Y, Rx, Ry, Hat0X, Hat0Y) and 13 buttons


