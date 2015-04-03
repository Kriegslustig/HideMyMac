#!/bin/bash

if [ -e ${1} ]; then
  echo "The first argument is required"
  exit 1
fi

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
  echo 'Invalid interface'
  exit 1
fi

interface=$1

if ! [ -e $2 -a -e $3 ]; then
  setMACAddr $interface $2
  setHostname $3
else
  echo "
  To reset your ${interface} do:"
  echo "sudo sh hideMyMac.sh ${interface} $(getCurrentMACAddr $interface) $(hostname)"
  setMACAddr ${interface} $(genNewMACAddr)
  setHostname '_'
fi

sleep 2
echo "New inteface:"
echo "Hostname: $(hostname)"
ifconfig $interface
exit 0