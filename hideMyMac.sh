#!/bin/bash

sendError () {
  echo "FAILED: ${1}"
  setHostname ${oldHostname}
  exit 1
}

hasFailed () {
  if ! [ $? -eq 0 ]; then
    sendError $1
  fi
}

displayNetworkStatus () {
  echo "New inteface:"
  echo "  Hostname: $(hostname)"
  echo "  MAC-Address: $(getCurrentMACAddr ${1})"
}

showHowToReset () {
  echo "\nTo reset your ${interface} do:"
  echo "  sudo sh hideMyMac.sh ${interface} ${oldMACAddr} ${oldHostname}\n"
}

doesThisInterfaceExsist () {
  ifconfig $1 &> /dev/null
  if ! [ $? -eq 0 ]; then
    sendError 'No such interface'
  fi
}

getCurrentMACAddr () {
  findEtherReg='[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]'
  ifconfig ${1} | grep -o ${findEtherReg}
}

setMACAddr () {
  ifconfig ${1} ether ${2}
  hasFailed 'Unable to set MAC Address, the interface might be down'
}

setHostname () {
  scutil --set HostName $1
}

genNewMACAddr () {
  # THX to [serverfault.com/users/1375/womble](serverfault/u/womble)
  openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'
}

interface=${1}
oldMACAddr=$(getCurrentMACAddr ${interface})
oldHostname=$(hostname)

if [ -e ${interface} ]; then
  sendError "The first argument is required"
fi

doesThisInterfaceExsist $interface

if ! [ -e $2 -a -e $3 ]; then
  if [ $2 = ${oldMACAddr} ]; then
    sendError "MAC Address has to change"
  fi
  setMACAddr $interface $2
  setHostname $3
else
  showHowToReset
  setMACAddr ${interface} $(genNewMACAddr)
  setHostname '_'
fi

while [[ -n $(getCurrentMACAddr ${interface} | grep ${oldMACAddr}) ]]; do
  sleep 0.1
done
displayNetworkStatus $interface
exit 0