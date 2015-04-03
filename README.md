# HideMyMac
A shell script that hides your Mac

## Usage

Before you hide yourself you must disconnect all interfaces form the Internet. Do not deactivate them. You can't change a deactivated interface. So unplug your ethernet cable and disconnect all Wi-Fi networks.

If you now do `ifconfig <someInterface>` you should see no IP and the `status` should be `inactive`.

Now you can hide:

```
  $ sudo sh hideMyMac.sh <someInterface>
    To reset your <someInterface> do:
  sudo sh hideMyMac.sh <someInterface> xx:xx:xx:xx:xx:xx towel
  New inteface:
  Hostname: _
  <someInterface>: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
          ether 0c:18:eb:25:a8:01
          nd6 options=1<PERFORMNUD>
          media: autoselect (<unknown type>
          status: inactive
```

As you can see, the hostname and MAC-Address of `<someInterface>` have changed. When you're done hiding you can reset your interface using the command provided by the script. Again before doing that, you have to disconnect from all networks.

```
  sudo sh hideMyMac.sh <someInterface> xx:xx:xx:xx:xx:xx towel
  New inteface:
  Hostname: _
  <someInterface>: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
          ether xx:xx:xx:xx:xx:xx
          nd6 options=1<PERFORMNUD>
          media: autoselect (<unknown type>
          status: inactive  
```

Then you can reconnect to your network.

### <someInterface>
The one you're using is probably `en0`