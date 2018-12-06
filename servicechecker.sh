#!/bin/bash
#
# To provide uninterrupted services there is a need to regularly check if they are running properly. 
# If one of them stopped, it needs to be restarted immediately.
#
# Servicechecker.sh is a generic script that will take the process name of a server, check if it is running and if not, 
# then run it using /sbin/service name start or server specific initialization programs.
#
# Stephen Turner
# *************************************************************************************************
# Variable Declaration
declare strService=$1			# String - service name
declare boolLoop=$2			# Boolean - loop optional param

# *************************************************************************************************
# Function Declearation
function helpout {

  echo Usage:
  echo " servicechecker servicename [LOOP]"
  echo " start the service if not running"
  echo;
  echo "  servicename		the name of the service"
  echo "  [LOOP]		optional - infinate loop checks status of service"
  echo;
  echo Example:
  echo "  servicechecker httpd		if the httpd service is not running start it."
  echo "  servicechecker httpd LOOP	infinate loop - service not running start it."
  exit 0

}

declare -t helpout		# Function - Help output

function funcServiceStarter {
# if not $strService is empty
if ! [ -z "$strService" ]; then
  # if not "(running)" is found within the service status output then start the service
  if ! (systemctl status $strService | grep -q "(running)"); then
      systemctl start $strService
  fi
else
  helpout
fi
}

declare -t funcServiceStarter		# Function - Service Checker
# *************************************************************************************************
# MAIN

funcServiceStarter
# Initial call to main funcServiceStarter

if ! [ -z "$boolLoop" ]; then
#if $boolLoop = LOOP then start an infinate loop doing funcServiceStarter
boolLoop=$(echo $boolLoop | awk '{print toupper($0)}')

  if [ "$boolLoop" = "LOOP" ]; then
    echo  - if $strService NOT "(running)" then
    echo  "-  systemctl start $strService"
    echo  - fi
    echo
    echo  -- Looping - ctrl+c to stop...
    while true ; do
      funcServiceStarter
    done
  else
    echo - ERROR - param for LOOP not known.
    helpout
  fi
fi   
