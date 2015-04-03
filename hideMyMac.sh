#!/bin/bash

if [ -e ${1} ]; then
  echo "The first argument is required"
  exit 1
fi

sendError () {
  echo $1
  exit 1
}

displayNetworkStatus () {
  echo "New inteface:"
  echo "Hostname: $(hostname)"
  ifconfig $1
}

showHowToReset () {
  echo "
  To reset your ${interface} do:"
  echo "sudo sh hideMyMac.sh ${interface} ${oldMACAddr} $(hostname)"
}

doesThisInterfaceExsist () {
  ifconfig $1 &> /dev/null
  if [ $? -eq 0 ]; then
    echo true
  fi
}

getCurrentMACAddr () {
  findEtherReg='[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]\:[[:alnum:]][[:alnum:]]'
  ifconfig "${1}" | grep -o ${findEtherReg}
}

setMACAddr () {
  ifconfig $1 ether $2
}

setHostname () {
  scutil --set HostName $1
}

genNewMACAddr () {
  # THX to [serverfault.com/users/1375/womble](serverfault/u/womble)
  openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'
}

if ! [ $(doesThisInterfaceExsist $1) ]; then
  sendError 'Invalid interface'
fi

interface=$1
oldMACAddr=$(getCurrentMACAddr $interface)

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